//
//  Utils.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "Utils.h"

// Utils

@implementation Utils

+ (nonnull NSNumber*) amountFromString:(nonnull NSString*)string
{
    NSString* trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSNumber* number = [[NSNumberFormatter new] numberFromString:trimmed];
    
    if (number != nil)
    {
        return @(fabs([number doubleValue]));
    }
    
    return @(0);
}

+ (nonnull NSString*) formatStringForDouble:(double)value
{
    // Get the int value and define the precision.
    
    NSInteger intValue = (int)(fabs(value) * 10000);    // 77.12345678 -> 771234
    intValue -= intValue % 100;                         // 771234 -> 771200
    intValue /= 100;                                    // 771200 -> 7712
    intValue %= 100;                                    // 7712 -> 12
    
    return (intValue == 0 ? @"%.0f" : @"%.2f");
}

+ (nullable NSString*) stringFromAmount:(nonnull NSNumber*)amount
{
    if (amount == nil || fabs(amount.doubleValue) < 0.01)
    {
        return @"";
    }
    
    const double value = fabs(amount.doubleValue);
    NSString* format = [Utils formatStringForDouble:value];
    
    return [NSString stringWithFormat:format, value];
}

@end
