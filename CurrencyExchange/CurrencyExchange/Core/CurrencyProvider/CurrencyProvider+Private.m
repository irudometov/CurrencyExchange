//
//  CurrencyProvider+Private.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider+Private.h"

@implementation CurrencyProvider (Private)

- (void) setNewPairs:(nonnull NSArray<CurrencyPair*>*)pairs
{
    [self setValue:pairs forKey:@"pairs"];
}

@end
