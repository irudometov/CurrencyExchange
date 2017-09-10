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

@property (nonnull, nonatomic, readonly) AccountRecord* sourceRecord;
@property (nonnull, nonatomic, readonly) AccountRecord* destinationRecord;

// A basic mechanism to exchange currencies between 2 records.

- (void) exchange:(double)amount
       fromRecord:(nonnull AccountRecord*)source
         toRecord:(nonnull AccountRecord*)destination;

@end
