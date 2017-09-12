//
//  Account.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "Account.h"
#import "CurrencyProvider.h"

NSString* _Nonnull const AccountErrorDomain = @"com.irudometov.errordomain.Account";

const NSInteger kError_InvalidAccountRecords = 100;
const NSInteger kError_AccountRecordNotFound = 101;
const NSInteger kError_InvalidAmount = 102;
const NSInteger kError_InsufficientFunds = 103;

// Account

@interface Account ()

@end

@implementation Account
{
    NSObject* _lockObject;
    NSMutableArray<AccountRecord*>* _records;
}

#pragma mark - Initialization

- (nullable instancetype) init
{
    if (self = [super init])
    {
        _lockObject = [NSObject new];
        _records = [NSMutableArray<AccountRecord*> new];
    }
    
    return self;
}

#pragma mark - Properties

- (nonnull NSArray<AccountRecord*>*) records
{
    NSArray<AccountRecord*>* buffer = nil;
    
    @synchronized (_lockObject)
    {
        buffer = [NSArray arrayWithArray:_records];
    }
    
    return buffer;
}

#pragma mark - Manage records

- (void) addRecord:(nonnull AccountRecord*)record
{
    @synchronized (_lockObject)
    {
        if ([self recordForCurrencyCode:record.currency.code] == nil)
        {
            [_records addObject:record];
        }
    }
}

- (nullable AccountRecord*) recordForCurrencyCode:(nonnull NSString*)code
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.currency.code == %@", code];
    return [[self.records filteredArrayUsingPredicate:predicate] firstObject];
}

#pragma mark - Exchange money

- (BOOL) performExchangeTransaction:(nonnull ExchangeTransaction*)transaction error:(NSError* _Nonnull __autoreleasing *_Nullable)error
{
    NSNumber* errorCode = nil;
    
    // Make sure source and target have different currencies.
    
    AccountRecord* source = [self recordForCurrencyCode:transaction.sourceCurrency.code];
    AccountRecord* target = [self recordForCurrencyCode:transaction.targetCurrency.code];
    
    if (source == nil || target == nil)
    {
        errorCode = @(kError_AccountRecordNotFound);
    }
    else if ([source.currency isEqual:target.currency] || source == target)
    {
        errorCode = @(kError_InvalidAccountRecords);
    }
    else if (transaction.amountToTake <= 0 || transaction.amountToPut <= 0)
    {
        errorCode = @(kError_InvalidAmount);
    }
    else if (source.amount - transaction.amountToTake < -0.01)
    {
        errorCode = @(kError_InsufficientFunds);
    }
    
    if (errorCode != nil)
    {
        if (error != NULL)
        {
            NSString* localizedDescription = [[self class] localizedDescriptionForErrorCode:errorCode.integerValue];
            *error = [NSError errorWithDomain:AccountErrorDomain code:errorCode.integerValue userInfo:@{ NSLocalizedDescriptionKey : localizedDescription }];
        }
        
        return NO;
    }
    
    // Commit transaction: create new source and target records to replace existing.
    
    @synchronized (_lockObject)
    {
        const NSInteger sourceIndex = [_records indexOfObject:source];
        const NSInteger targetIndex = [_records indexOfObject:target];
        
        const double newSourceAmount = MAX(0, source.amount - transaction.amountToTake);
        const double newTargetAmount = MAX(0, target.amount + transaction.amountToPut);
        
        AccountRecord* newSource = [AccountRecord recordWithCurrency:source.currency amount:newSourceAmount];
        AccountRecord* newTarget = [AccountRecord recordWithCurrency:target.currency amount:newTargetAmount];
        
        [_records replaceObjectAtIndex:sourceIndex withObject:newSource];
        [_records replaceObjectAtIndex:targetIndex withObject:newTarget];
    }
    
    return YES;
}

#pragma mark - Localized error code

+ (nonnull NSString*) localizedDescriptionForErrorCode:(NSInteger)errorCode
{
    NSString* key = nil;
    
    switch (errorCode)
    {
        case kError_InvalidAccountRecords:
            key = @"error_invalid_account_records";
            break;
            
        case kError_AccountRecordNotFound:
            key = @"error_account_record_not_found";
            break;
            
        case kError_InvalidAmount:
            key = @"error_invalid_amount";
            break;
            
        case kError_InsufficientFunds:
            key = @"error_insufficient_funds";
            break;
            
        default:
            break;
    }
    
    if (key != nil)
    {
        return NSLocalizedStringFromTable(key, @"Errors", nil);
    }
    
    return NSLocalizedStringFromTable(@"unknown_error", @"Errors", nil);
}

@end
