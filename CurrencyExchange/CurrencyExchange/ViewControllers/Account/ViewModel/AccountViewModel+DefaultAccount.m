//
//  AccountViewModel+DefaultAccount.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewModel+DefaultAccount.h"

const double kDefaultMoneyAmount = 100;

// Account view model

@implementation AccountViewModel (DefaultAccount)

+ (nonnull Account*) defaultAccount
{
    Account* account = [Account new];
    
    // Add 3 currencies of 100 units per each.
    
    [account addRecord:[AccountRecord recordWithCurrency:[Currency EUR] amount:kDefaultMoneyAmount]];
    [account addRecord:[AccountRecord recordWithCurrency:[Currency USD] amount:kDefaultMoneyAmount]];
    [account addRecord:[AccountRecord recordWithCurrency:[Currency GBP] amount:kDefaultMoneyAmount]];
    
    return account;
}

+ (nullable instancetype) defaultAccountViewModel
{
    Account* defaultAccount = [self defaultAccount];
    return [AccountViewModel viewModelForAccount:defaultAccount];
}

@end
