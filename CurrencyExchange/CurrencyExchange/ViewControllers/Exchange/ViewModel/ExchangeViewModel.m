//
//  ExchangeViewModel.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "ExchangeViewModel.h"
#import "AccountViewModel+Private.h"
#import "CurrencyProvider.h"
#import "NSNumber+Currency.h"

// Exchange view model

@implementation ExchangeViewModel
{
    double _unitsToExchange;
    BOOL _isLocked;
}

- (nullable instancetype) initWithAccount:(nonnull Account*)account
{
    if (self = [super initWithAccount:account])
    {
        _unitsToExchange = 0;
        _sourceRecordIndex = 0;
        _targetRecordIndex = MIN(MAX(self.numberOfRecords - 1, 0), 1);
        [self subscribeForNotifications];
    }
    
    return self;
}

- (void) dealloc
{
    [self unsubscribeFromNotifications];
}

#pragma mark - Subscribe for notifications

- (void) subscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRatesUpdated:) name:kNotification_CurrencyRatesUpdated object:[CurrencyProvider sharedInstance]];
}

- (void) unsubscribeFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onRatesUpdated:(nonnull NSNotification*)notification
{
    // Here we should recalculate the current state using the last rates.
    
    if ([self.presenter respondsToSelector:@selector(viewModelDidUpdate:)])
    {
        [self.presenter viewModelDidUpdate:self];
    }
}

#pragma mark - Amount

- (nullable NSNumber*) unitsToExchangeInCurrency:(nonnull Currency*)currency
{
    return [[CurrencyProvider sharedInstance] amountFromUnits:self.unitsToExchange inCurrency:currency];
}

#pragma mark - Records

- (void) setSourceRecordIndex:(NSUInteger)newIndex
{
    _sourceRecordIndex = MIN(newIndex, MAX(self.numberOfRecords - 1, 0));
}

- (void) setTargetRecordIndex:(NSUInteger)newIndex
{
    _targetRecordIndex = MIN(newIndex, MAX(self.numberOfRecords - 1, 0));
}

- (nonnull AccountRecord*) sourceRecord
{
    return [self recordAtIndex:self.sourceRecordIndex];
}

- (nonnull AccountRecord*) targetRecord
{
    return [self recordAtIndex:self.targetRecordIndex];
}

#pragma mark - Access currency info

- (nonnull Currency*) sourceCurrencyAtIndex:(NSInteger)index
{
    return [self currencyAtIndex:index];
}

- (nonnull Currency*) destinationCurrencyAtIndex:(NSInteger)index
{
    return [self currencyAtIndex:index];
}

#pragma mark - Current balance

- (double) balanceForRecortAtIndex:(NSInteger)index
{
    AccountRecord* record = [super recordAtIndex:index];
    NSNumber* balance = [[CurrencyProvider sharedInstance] unitsFromAmount:record.amount forCurrency:record.currency];
    
    return (balance != nil ? balance.doubleValue : 0);
}

- (BOOL) hasEnoughMoneyForRecordAtIndex:(NSInteger)index
{
    const double balance = [self balanceForRecortAtIndex:index];
    
    if (self.unitsToExchange >= 0.01)
    {
        const double delta = balance - self.unitsToExchange;
        return delta >= -0.000001;
    }
    
    return balance >= 0;
}

#pragma mark - Exchange

// A basic mechanism to exchange currencies between 2 records.

- (BOOL) exchange:(NSError* _Nonnull __autoreleasing *_Nullable)error
{
    [self unsubscribeFromNotifications];
    
    @try
    {
        AccountRecord* source = self.sourceRecord;
        AccountRecord* target = self.targetRecord;
        
        CurrencyProvider* provider = [CurrencyProvider sharedInstance];
        
        NSNumber* amountToTake = [provider convert:self.unitsToExchange from:provider.baseCurrency to:source.currency error:error];
        
        if (amountToTake == nil)
        {
            return NO;
        }
        
        NSNumber* amountToPut = [provider convert:self.unitsToExchange from:provider.baseCurrency to:target.currency error:error];
        
        if (amountToPut == nil)
        {
            return NO;
        }
        
        ExchangeTransaction* transaction = [ExchangeTransaction transactionWithSourceCurrency:source.currency amountToTake:amountToTake.doubleValue targetCurrency:target.currency amountToPut:amountToPut.doubleValue];
        
        if (transaction != nil)
        {
            return [self.account performExchangeTransaction:transaction error:error];
        }
        
        return NO;
    }
    @catch (NSException *exception)
    {
        return NO;
    }
    @finally
    {
        [self subscribeForNotifications];
    }
}

#pragma mark - Localization

- (nonnull NSString*) localizedBalanceForRecordAtIndex:(NSInteger)index checkEnoughMoney:(BOOL)checkEnoughMoney
{
    AccountRecord* record = [super recordAtIndex:index];
    const BOOL enough = (checkEnoughMoney ? [self hasEnoughMoneyForRecordAtIndex:index] : YES);
    
    return [[self class] localizedBalanceForRecord:record enough:enough];
}

+ (nonnull NSString*) localizedBalanceForRecord:(nonnull AccountRecord*)record enough:(BOOL)enough
{
    NSString* amount = [@(record.amount) formatAsCurrency:record.currency];
    
    if (amount == nil)
    {
        amount = @(record.amount).stringValue;
    }
    
    NSString* format = (enough || record.amount >= 0.01 ? @"account_record_balance_format" : @"account_record_is_empty");
    
    return [NSString stringWithFormat:NSLocalizedString(format, nil), amount];
}

+ (nonnull NSString*) localizedRateFrom:(nonnull Currency*)source to:(nonnull Currency*)target
{
    NSString* localizedSource = [@(1) formatAsCurrency:source];
    NSNumber* rate = [[CurrencyProvider sharedInstance] conversionRateFrom:source to:target];
    
    if (rate != nil)
    {
        return [NSString stringWithFormat:@"%@=%@", localizedSource, [rate formatAsCurrency:target]];
    }
    
    return @"";
}

- (nonnull NSString*) localizedRate
{
    return [[self class] localizedRateFrom:self.sourceRecord.currency to:self.targetRecord.currency];
}

@end
