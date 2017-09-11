//
//  AccountRecord.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

// A record on bank account for a particular currency.

@interface AccountRecord : NSObject

@property (nonnull, nonatomic, readonly) Currency* currency;
@property (nonatomic, readonly) double amount;
@property (nonnull, nonatomic, readonly) NSString* localizedAmountString;

+ (nullable instancetype) recordWithCurrency:(nonnull Currency*)currency amount:(double)amount;

@end
