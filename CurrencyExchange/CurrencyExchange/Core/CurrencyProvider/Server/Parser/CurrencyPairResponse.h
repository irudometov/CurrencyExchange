//
//  CurrencyPairResponse.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 12/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyPair.h"

// This class incapsultes the server response in a single object.

@interface CurrencyPairResponse : NSObject

@property (nonnull, nonatomic, copy, readonly) NSString* timeString;
@property (nonnull, nonatomic, readonly) NSArray<CurrencyPair*>* pairs;

+ (nullable instancetype) responseWithPairs:(NSArray<CurrencyPair*>*)pairs timeString:(nonnull NSString*)timeString;

@end
