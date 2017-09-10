//
//  CurrencyProvider.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider.h"

const NSTimeInterval CURRENCY_REFRESH_TIME_INTERVAL = 30; // sec

// Currency provider

@implementation CurrencyProvider
{
    CurrencyProviderCallback _callback;
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
        _refreshTimeInterval = CURRENCY_REFRESH_TIME_INTERVAL;
    }
    
    return self;
}

#pragma mark - Refresh

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback
{
    _callback = callback;
}

@end
