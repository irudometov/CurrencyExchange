//
//  CurrencyPairResponse.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 12/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyPairResponse.h"

// Currency pair response

@implementation CurrencyPairResponse

+ (nullable instancetype) responseWithPairs:(NSArray<CurrencyPair*>*)pairs timeString:(nonnull NSString*)timeString
{
    return [[self alloc] initWithPairs:pairs timeString:timeString];
}

- (nullable instancetype) initWithPairs:(NSArray<CurrencyPair*>*)pairs timeString:(nonnull NSString*)timeString
{
    if (self = [super init])
    {
        _pairs = [[NSArray alloc] initWithArray:pairs];
        _timeString = [timeString copy];
    }
    
    return self;
}

@end
