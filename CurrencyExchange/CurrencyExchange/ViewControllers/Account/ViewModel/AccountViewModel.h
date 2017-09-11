//
//  AccountViewModel.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

// A view model to display user's bank account.

@interface AccountViewModel : NSObject

@property (nonnull, nonatomic, readonly) Account* account;

+ (nullable instancetype) viewModelForAccount:(nonnull Account*)account;

- (NSInteger) numberOfRecords;

- (nonnull AccountRecord*) recordAtIndex:(NSInteger)index;
- (nonnull Currency*) currencyAtIndex:(NSInteger)index;

@end
