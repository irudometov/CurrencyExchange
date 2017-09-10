//
//  AccountViewModel+DefaultAccount.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewModel.h"

extern const double kDefaultMoneyAmount;

// A category to create a default account.

@interface AccountViewModel (DefaultAccount)

+ (nullable instancetype) defaultAccountViewModel;

@end
