//
//  AccountViewModel.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewModel.h"
#import "AccountViewModel+Private.h"

// Account view model

@interface AccountViewModel ()

@property (nonnull, nonatomic, readwrite) Account* account;

@end

@implementation AccountViewModel

#pragma mark - Initialization

+ (nullable instancetype) viewModelForAccount:(nonnull Account*)account
{
    return [[[self class] alloc] initWithAccount:account];
}

#pragma mark - Access account records

- (NSInteger) numberOfRecords
{
    return self.account.records.count;
}

- (nonnull AccountRecord*) recordAtIndex:(NSInteger)index
{
    NSAssert(index >= 0 && index < self.numberOfRecords, @"Index %ld is out of bounds [0, %ld].", (long)index, (long)self.numberOfRecords);
    
    return self.account.records[index];
}

- (nonnull Currency*) currencyAtIndex:(NSInteger)index
{
    return [self recordAtIndex:index].currency;
}

@end
