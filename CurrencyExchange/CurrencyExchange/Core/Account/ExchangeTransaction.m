//
//  ExchangeTransaction.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "ExchangeTransaction.h"
#import "Currency.h"

// Exchange transaction

@implementation ExchangeTransaction

+ (nullable instancetype) transactionWithSourceCurrency:(nonnull Currency*)source
                                           amountToTake:(double)amountToTake
                                         targetCurrency:(nonnull Currency*)target
                                            amountToPut:(double)amountToPut
{
    if ([source isEqual:target])
    {
        NSLog(@"Fail to create an exchange transaction with the same source and target currencies.");
        return nil;
    }
    
    if (amountToPut < 0 || amountToPut < 0)
    {
        NSLog(@"Fail to create an exchange transaction with negative amount to put or negative amount to take.");
        return nil;
    }
    
    return [[[self class] alloc] initWithSourceCurrency:source amountToTake:amountToTake targetCurrency:target amountToPut:amountToPut];
}

- (instancetype) initWithSourceCurrency:(nonnull Currency*)source
                           amountToTake:(double)amountToTake
                         targetCurrency:(nonnull Currency*)target
                            amountToPut:(double)amountToPut
{
    if (self = [super init])
    {
        _sourceCurrency = source;
        _targetCurrency = target;
        _amountToTake = amountToTake;
        _amountToPut = amountToPut;
    }
    
    return self;
}

@end
