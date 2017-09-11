//
//  ExchangeTransaction.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

// A transaction to exchange money between two different account records.

@interface ExchangeTransaction : NSObject

@property (nonnull, nonatomic, readonly) Currency* sourceCurrency;
@property (nonnull, nonatomic, readonly) Currency* targetCurrency;

@property (nonatomic, readonly) double amountToTake;
@property (nonatomic, readonly) double amountToPut;

+ (nullable instancetype) transactionWithSourceCurrency:(nonnull Currency*)source
                                           amountToTake:(double)amountToTake
                                         targetCurrency:(nonnull Currency*)target
                                            amountToPut:(double)amountToPut;

@end
