//
//  AccountRecord.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountRecord.h"
#import "NSNumber+Currency.h"

// Account record

@interface AccountRecord ()

@property (nonnull, nonatomic, readwrite) Currency* currency;
@property (nonatomic, readwrite) double amount;

@end

@implementation AccountRecord

#pragma mark - Initialization

+ (nullable instancetype) recordWithCurrency:(nonnull Currency*)currency amount:(double)amount
{
    return [[[self class] alloc] initWithCurrency:currency amount:amount];
}

- (nullable instancetype) initWithCurrency:(nonnull Currency*)currency amount:(double)amount
{
    if (self = [super init])
    {
        self.currency = currency;
        self.amount = amount;
    }
    
    return self;
}

- (nonnull NSString*) localizedAmountString
{
    return [@(self.amount) formatAsCurrency:self.currency];
}

@end
