//
//  Currency.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* _Nonnull const kCurrencyCode_EUR;
extern NSString* _Nonnull const kCurrencyCode_USD;
extern NSString* _Nonnull const kCurrencyCode_GBP;

// This class describes a single currency.

@interface Currency : NSObject

@property (nonnull, nonatomic, copy, readonly) NSString* code;
@property (nonnull, nonatomic, copy, readonly) NSString* lowercaseCode;

+ (nullable instancetype) currencyWithCode:(nonnull NSString*)code;

+ (nullable instancetype) EUR;
+ (nullable instancetype) USD;
+ (nullable instancetype) GBP;

@end
