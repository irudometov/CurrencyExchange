//
//  AccountViewModel+Private.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewModel.h"
#import "Account.h"

@interface AccountViewModel (Private)

- (nullable instancetype) initWithAccount:(nonnull Account*)account;

@end
