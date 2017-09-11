//
//  CurrencyProvider.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider.h"

const NSTimeInterval CURRENCY_REFRESH_TIME_INTERVAL = 30; // sec
const double CONVERSTION_RATE_EQUAL = 1.0;

// Currency provider

@implementation CurrencyProvider
{
    CurrencyProviderCallback _callback;
    NSMutableArray<Currency*>* _currencies;
    NSMutableArray<CurrencyPair*>* _pairs;
}

#pragma mark - Shared Instance

+ (nonnull CurrencyProvider*) sharedInstance
{
    static CurrencyProvider* __sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [self new];
    });
    
    return __sharedInstance;
}

#pragma mark - Initialization

- (nullable instancetype)init
{
    if (self = [super init])
    {
        _baseCurrency = [Currency EUR];
        _refreshTimeInterval = CURRENCY_REFRESH_TIME_INTERVAL;
        
        _currencies = [NSMutableArray<Currency*> new];
        _pairs = [NSMutableArray<CurrencyPair*> new];
        
        [self initDefaultPairs];
    }
    
    return self;
}

- (void) initDefaultPairs
{
    Currency* eur = [Currency EUR];
    Currency* usd = [Currency USD];
    Currency* gbp = [Currency GBP];
    
    [_currencies addObjectsFromArray:@[eur, usd, gbp]];
    
    // Build default pairs.
    
    CurrencyPair* eur_usd = [CurrencyPair pairWithSource:eur target:usd rate:1.2060];
    CurrencyPair* eur_gbp = [CurrencyPair pairWithSource:eur target:gbp rate:0.91268];
    
    [_pairs addObjectsFromArray:@[eur_usd, eur_gbp]];
}

#pragma mark - Convert

- (nullable NSNumber*) convert:(double)amount
                          from:(nonnull Currency*)source
                            to:(nonnull Currency*)target
                         error:(NSError* _Nonnull __autoreleasing *_Nullable)error
{
    // Find appropriate pairs to calculate the rate of <source, target> pair.
    
    NSNumber* rate = [self conversionRateFrom:source to:target];
    
    if (rate != nil)
    {
        return @(fabs(amount * rate.doubleValue));
    }
    
    return nil;
}

- (nullable CurrencyPair*) findBasePairForCurrency:(nonnull Currency*)currency
{
    if (self.baseCurrency == nil)
    {
        NSLog(@"Base currency is not set.");
        return nil;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable obj, NSDictionary<NSString *,id> * _Nullable bindings)
    {
        CurrencyPair* pair = (CurrencyPair*)obj;
        
        return ([pair.target isEqual:currency] &&
                [pair.source isEqual:self.baseCurrency]);
    }];
    
    return [[self.pairs filteredArrayUsingPredicate:predicate] firstObject];
}

- (nullable NSNumber*) conversionRateForCurrency:(nonnull Currency*)currency
{
    if ([self isBaseCurrency:currency])
    {
        return @(CONVERSTION_RATE_EQUAL);
    }
    
    // Find an appropriate currency pair and use its rate.
    
    CurrencyPair* pair = [self findBasePairForCurrency:currency];
    
    return (pair != nil ? @(pair.rate) : nil);
}

- (nullable NSNumber*) conversionRateFrom:(nonnull Currency*)source to:(nonnull Currency*)target
{
    if ([source isEqual:target])
    {
        return @(CONVERSTION_RATE_EQUAL);
    }
    
    const BOOL isBaseSource = [self isBaseCurrency:source];
    const BOOL isBaseTarget = [self isBaseCurrency:target];
    
    NSAssert(!(isBaseSource && isBaseTarget), @"Source and target can't be the base currencies at the same time.");
    
    // Use an existing rate for the target currency.
    
    if (isBaseSource)
    {
        return [self conversionRateForCurrency:target];
    }
    
    // Use the inverse rate for the source currency.
    
    if (isBaseTarget)
    {
        NSNumber* rate = [self conversionRateForCurrency:source];
        
        if (rate != nil)
        {
            return @(1 / rate.doubleValue);
        }
    }
    
    // Convert source to base and then base to the target.
    
    NSNumber* sourceRate = [self conversionRateForCurrency:source];
    NSNumber* targetRate = [self conversionRateForCurrency:target];
    
    if (sourceRate != nil && sourceRate.doubleValue > 0 &&
        targetRate != nil && targetRate.doubleValue > 0)
    {
        return @(fabs(targetRate.doubleValue / sourceRate.doubleValue));
    }
    
    return nil;
}

- (BOOL) isBaseCurrency:(nonnull Currency*)currency
{
    return (self.baseCurrency != nil ? [self.baseCurrency isEqual:currency] : NO);
}

#pragma mark - Calculations

- (nullable NSNumber*) unitsFromAmount:(double)amount forCurrency:(nonnull Currency*)currency
{
    if ([self isBaseCurrency:currency])
    {
        return @(fabs(amount));
    }
    
    NSNumber* rate = [[CurrencyProvider sharedInstance] conversionRateForCurrency:currency];
    
    return (rate != nil ? @(fabs(amount / rate.doubleValue)) : nil);
}

- (nullable NSNumber*) amountFromUnits:(double)units inCurrency:(nonnull Currency*)currency
{
    if ([[CurrencyProvider sharedInstance] isBaseCurrency:currency])
    {
        return @(fabs(units));
    }
    
    NSNumber* rate = [[CurrencyProvider sharedInstance] conversionRateForCurrency:currency];
    
    return (rate != nil ? @(fabs(units * rate.doubleValue)) : nil);
}

#pragma mark - Refresh courses

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback
{
    _callback = callback;
}

@end
