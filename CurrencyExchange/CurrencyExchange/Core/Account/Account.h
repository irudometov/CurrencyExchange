//
//  Account.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountRecord.h"
#import "ExchangeTransaction.h"

// Errors

extern NSString* _Nonnull const AccountErrorDomain;

extern const NSInteger kError_InvalidAccountRecords;
extern const NSInteger kError_AccountRecordNotFound;
extern const NSInteger kError_InvalidAmount;
extern const NSInteger kError_InsufficientFunds;

// This class represents an analogue of 'bank account' with several currencies.

@interface Account : NSObject

@property (nonnull, nonatomic, readonly) NSArray<AccountRecord*>* records;

- (void) addRecord:(nonnull AccountRecord*)record;

- (BOOL) performExchangeTransaction:(nonnull ExchangeTransaction*)transaction error:(NSError* _Nonnull __autoreleasing *_Nullable)error;

@end
