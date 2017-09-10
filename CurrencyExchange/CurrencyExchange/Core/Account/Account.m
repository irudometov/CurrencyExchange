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
    if ([self recordForCurrencyCode:record.currency.code] == nil)
    {
        [_records addObject:record];
    }
}

- (nullable AccountRecord*) recordForCurrencyCode:(nonnull NSString*)code
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.currency.code == %@", code];
    return [[self.records filteredArrayUsingPredicate:predicate] firstObject];
}

@end
