//
//  NSNumber+Currency.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "NSNumber+Currency.h"
#import "Currency.h"

@implementation NSNumber (Currency)

- (nullable NSString*) formatAsCurrency:(nonnull Currency*)currency
{
    return [self formatAsCurrencyWithCode:currency.code];
}

- (nullable NSString*) formatAsCurrencyWithCode:(nonnull NSString*)currencyCode
{
    static NSNumberFormatter* __currencyFormatter = nil;
    
    if (__currencyFormatter == nil)
    {
        __currencyFormatter = [NSNumberFormatter new];
        __currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    const NSInteger fractionDigits = (floor(self.doubleValue) == self.doubleValue ? 0 : 2);
    __currencyFormatter.minimumFractionDigits = fractionDigits;
    __currencyFormatter.maximumFractionDigits = fractionDigits;
    
    __currencyFormatter.currencyCode = currencyCode;
    
    return [__currencyFormatter stringFromNumber:self];
}

@end
