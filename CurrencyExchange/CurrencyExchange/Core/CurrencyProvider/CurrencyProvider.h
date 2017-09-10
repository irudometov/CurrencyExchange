//
//  CurrencyProvider.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@class CurrencyProvider;

typedef void (^CurrencyProviderCallback) (CurrencyProvider* _Nonnull provider, NSError* _Nullable error);

extern const NSTimeInterval CURRENCY_REFRESH_TIME_INTERVAL;

// A class to get updated currencies from the server.

@interface CurrencyProvider : NSObject

+ (nonnull CurrencyProvider*) sharedInstance;

@property (nonnull, nonatomic, readonly) Currency* baseCurrency;        // EUR for the server by default.
@property (nonnull, nonatomic, readonly) NSArray<Currency*>* currencies;

@property (nonatomic, readwrite) NSTimeInterval refreshTimeInterval;

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback;

@end
