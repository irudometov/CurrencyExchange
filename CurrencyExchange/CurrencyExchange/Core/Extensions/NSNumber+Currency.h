//
//  NSNumber+Currency.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

// Format numbers for currency.

@interface NSNumber (Currency)

- (nullable NSString*) formatAsCurrency:(nonnull Currency*)currency;
- (nullable NSString*) formatAsCurrencyWithCode:(nonnull NSString*)currencyCode;

@end
