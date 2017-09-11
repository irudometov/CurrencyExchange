//
//  ExchangeViewModel.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountViewModel.h"

// A view model to exchange currencies.

@interface ExchangeViewModel : AccountViewModel

@property (nonatomic, readwrite) double unitsToExchange;

@property (nonnull, nonatomic, readonly) AccountRecord* sourceRecord;
@property (nonnull, nonatomic, readonly) AccountRecord* destinationRecord;

- (nullable NSNumber*) unitsToExchangeInCurrency:(nonnull Currency*)currency;

- (nonnull Currency*) sourceCurrencyAtIndex:(NSInteger)index;
- (nonnull Currency*) destinationCurrencyAtIndex:(NSInteger)index;

// A basic mechanism to exchange currencies between 2 records.

- (void) exchange:(double)amount
       fromRecord:(nonnull AccountRecord*)source
         toRecord:(nonnull AccountRecord*)destination;

@end
