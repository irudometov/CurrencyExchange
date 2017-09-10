//
//  Currency.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "Currency.h"

NSString* _Nonnull const kCurrencyCode_EUR = @"EUR";
NSString* _Nonnull const kCurrencyCode_USD = @"USD";
NSString* _Nonnull const kCurrencyCode_GBP = @"GBP";

// Currency

@interface Currency ()

@property (nonnull, nonatomic, copy, readwrite) NSString* code;

@end

@implementation Currency

#pragma mark - Initialization

+ (nullable instancetype) currencyWithCode:(nonnull NSString*)code
{
    return [[[self class] alloc] initWithCode:code];
}

+ (nullable instancetype) EUR
{
    return [self currencyWithCode:kCurrencyCode_EUR];
}

+ (nullable instancetype) USD
{
    return [self currencyWithCode:kCurrencyCode_USD];
}

+ (nullable instancetype) GBP
{
    return [self currencyWithCode:kCurrencyCode_GBP];
}

- (nullable instancetype) initWithCode:(nonnull NSString*)code
{
    if (self = [super init])
    {
        self.code = code;
    }
    
    return self;
}

@end
