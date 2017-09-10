//
//  Account.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountRecord.h"

// This class represents an analogue of 'bank account' with several currencies.

@interface Account : NSObject

@property (nonnull, nonatomic, readonly) NSArray<AccountRecord*>* records;

- (void) addRecord:(nonnull AccountRecord*)record;

@end
