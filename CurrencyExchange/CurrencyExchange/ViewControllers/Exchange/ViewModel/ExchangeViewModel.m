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
    AccountRecord* _sourceRecord;
    AccountRecord* _destinationRecord;
    
    double _unitsToExchange;
}

- (nullable instancetype) initWithAccount:(nonnull Account*)account
{
    if (self = [super initWithAccount:account])
    {
        _unitsToExchange = 0;
    }
    
    return self;
}

#pragma mark - Update records

- (void) setupInitialRecords
{
    if (self.numberOfRecords > 1)
    {
        _sourceRecord = [self recordAtIndex:0];
        _destinationRecord = [self recordAtIndex:1];
    }
}

#pragma mark - Amount

- (nullable NSNumber*) unitsToExchangeInCurrency:(nonnull Currency*)currency
{
    return [[CurrencyProvider sharedInstance] amountFromUnits:self.unitsToExchange inCurrency:currency];
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

#pragma mark - Exchange

// A basic mechanism to exchange currencies between 2 records.

- (void) exchange:(double)amount
       fromRecord:(nonnull AccountRecord*)source
         toRecord:(nonnull AccountRecord*)destination
{
    NSLog(@"exchange %.2f from %@ to %@", amount, source.currency.code, destination.currency.code);
}

@end
