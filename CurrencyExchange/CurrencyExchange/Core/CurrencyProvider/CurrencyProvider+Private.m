//
//  CurrencyProvider+Private.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider+Private.h"

NSString* _Nonnull const kNotification_CurrencyRatesUpdated = @"com.irudometov.notificaiton.CurrencyRatesUpdated";

// Currency provider

@implementation CurrencyProvider (Private)

- (void) setNewPairs:(nonnull NSArray<CurrencyPair*>*)pairs
{
    [self setValue:pairs forKey:@"pairs"];
    [self notifyRatesUpdated];
}

- (void) notifyRatesUpdated
{
    void (^block)(void) = ^ {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_CurrencyRatesUpdated object:self];
    };
    
    if ([NSThread isMainThread])
    {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
