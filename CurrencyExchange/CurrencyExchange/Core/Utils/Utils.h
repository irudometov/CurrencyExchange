//
//  Utils.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>

// A helper class to incapsulate common operations.

@interface Utils : NSObject

+ (nonnull NSNumber*) amountFromString:(nonnull NSString*)string;

+ (nullable NSString*) stringFromAmount:(nonnull NSNumber*)amount;

@end
