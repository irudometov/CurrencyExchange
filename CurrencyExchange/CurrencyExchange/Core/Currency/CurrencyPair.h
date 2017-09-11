//
//  CurrencyPair.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

// A pair of two currencies to know the rate.

@interface CurrencyPair : NSObject

@property (nonnull, nonatomic, readonly) Currency* source;
@property (nonnull, nonatomic, readonly) Currency* target;
@property (nonatomic, readonly) double rate;

+ (nullable instancetype) pairWithSource:(nonnull Currency*)source target:(nonnull Currency*)target rate:(double)rate;

@end
