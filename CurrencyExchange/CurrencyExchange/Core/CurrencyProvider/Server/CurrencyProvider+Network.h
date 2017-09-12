//
//  CurrencyProvider+Network.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider.h"

extern NSString* _Nonnull const kDailyStatXMLURLString;

// An extension of currency provider to work with network.

@interface CurrencyProvider (Network)

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback;

@end
