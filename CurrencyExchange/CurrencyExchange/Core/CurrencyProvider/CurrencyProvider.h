//
//  CurrencyProvider.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyPair.h"

@class CurrencyProvider;

typedef void (^CurrencyProviderCallback) (CurrencyProvider* _Nonnull provider, NSError* _Nullable error);

extern const NSTimeInterval CURRENCY_REFRESH_TIME_INTERVAL;

// A class to get updated currencies from the server.

@interface CurrencyProvider : NSObject

+ (nonnull CurrencyProvider*) sharedInstance;

@property (nonnull, nonatomic, readonly) Currency* baseCurrency;        // EUR for the server by default.
@property (nonnull, nonatomic, readonly) NSArray<Currency*>* currencies;
@property (nonnull, nonatomic, readonly) NSArray<CurrencyPair*>* pairs;

@property (nonatomic, readwrite) NSTimeInterval refreshTimeInterval;

- (BOOL) isBaseCurrency:(nonnull Currency*)currency;

- (nullable NSNumber*) convert:(double)amount
                          from:(nonnull Currency*)source
                            to:(nonnull Currency*)target
                         error:(NSError* _Nonnull __autoreleasing *_Nullable)error;

- (nullable NSNumber*) conversionRateForCurrency:(nonnull Currency*)currency;
- (nullable NSNumber*) conversionRateFrom:(nonnull Currency*)source to:(nonnull Currency*)target;

- (nullable NSNumber*) unitsFromAmount:(double)amount forCurrency:(nonnull Currency*)currency;
- (nullable NSNumber*) amountFromUnits:(double)units inCurrency:(nonnull Currency*)currency;

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback;

@end
