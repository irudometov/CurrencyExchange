//
//  Account.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "Account.h"

// Account

@interface Account ()

@end

@implementation Account
{
    NSMutableArray<AccountRecord*>* _records;
}

#pragma mark - Initialization

- (nullable instancetype) init
{
    if (self = [super init])
    {
        _records = [NSMutableArray<AccountRecord*> new];
    }
    
    return self;
}

#pragma mark - Properties

- (nonnull NSArray<AccountRecord*>*) records
{
    return _records;
}

#pragma mark - Manage records

- (void) addRecord:(nonnull AccountRecord*)record
{
#warning check record currency does not exist
    
    [_records addObject:record];
}

@end
