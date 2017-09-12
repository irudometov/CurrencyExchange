//
//  CurrencyPairResponseSerializer.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 12/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyPairResponse.h"

// A parser for the currency pair daily xml.

@interface CurrencyPairResponseSerializer : NSObject

@property (nonnull, nonatomic, readonly) Currency* baseCurrency;

+ (nonnull instancetype) serializerWithBaseCurrency:(nonnull Currency*)baseCurrency;

- (nullable CurrencyPairResponse*) parseCurrencyPairsFromResponse:(nonnull NSObject*)response error:(NSError* _Nonnull __autoreleasing *_Nullable)error;

@end
