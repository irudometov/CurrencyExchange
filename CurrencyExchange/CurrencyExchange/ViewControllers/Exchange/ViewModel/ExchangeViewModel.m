//
//  ExchangeViewModel.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "ExchangeViewModel.h"

// Exchange view model

@implementation ExchangeViewModel
{
    AccountRecord* _sourceRecord;
    AccountRecord* _destinationRecord;
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

#pragma mark - Exchange

// A basic mechanism to exchange currencies between 2 records.

- (void) exchange:(double)amount
       fromRecord:(nonnull AccountRecord*)source
         toRecord:(nonnull AccountRecord*)destination
{
    NSLog(@"exchange %.2f from %@ to %@", amount, source.currency.code, destination.currency.code);
}

@end
