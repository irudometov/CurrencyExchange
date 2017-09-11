//
//  CurrencyPair.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyPair.h"

// Currency pair

@interface CurrencyPair ()

@property (nonnull, nonatomic, readwrite) Currency* source;
@property (nonnull, nonatomic, readwrite) Currency* target;
@property (nonatomic, readwrite) double rate;

@end

@implementation CurrencyPair

+ (nullable instancetype) pairWithSource:(nonnull Currency*)source target:(nonnull Currency*)target rate:(double)rate
{
    return [[[self class] alloc] initWithSource:source target:target rate:rate];
}

- (instancetype) initWithSource:(nonnull Currency*)source target:(nonnull Currency*)target rate:(double)rate
{
    if (self = [super init])
    {
        self.source = source;
        self.target = target;
        self.rate = fabs(rate); // cause convertion rate can't be negative
    }
    
    return self;
}

@end
