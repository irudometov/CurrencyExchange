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

// Exchange view model

@implementation ExchangeViewModel
{
    double _unitsToExchange;
}

- (nullable instancetype) initWithAccount:(nonnull Account*)account
{
    if (self = [super initWithAccount:account])
    {
        _unitsToExchange = 0;
        _sourceRecordIndex = 0;
        _targetRecordIndex = 0;
    }
    
    return self;
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
    return (balance >= self.unitsToExchange);
}

#pragma mark - Exchange

// A basic mechanism to exchange currencies between 2 records.

- (void) exchange:(double)amount
       fromRecord:(nonnull AccountRecord*)source
         toRecord:(nonnull AccountRecord*)destination
{
    NSLog(@"exchange %.2f from %@ to %@", amount, source.currency.code, destination.currency.code);
}

@end
