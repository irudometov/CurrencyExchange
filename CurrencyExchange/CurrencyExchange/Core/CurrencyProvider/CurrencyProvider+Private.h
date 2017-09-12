//
//  CurrencyProvider+Private.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider.h"

@interface CurrencyProvider (Private)

- (void) setNewPairs:(nonnull NSArray<CurrencyPair*>*)pairs;

@end
