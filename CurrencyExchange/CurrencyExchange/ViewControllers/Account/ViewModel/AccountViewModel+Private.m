//
//  AccountViewModel+Private.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewModel+Private.h"

@implementation AccountViewModel (Private)

- (nullable instancetype) initWithAccount:(nonnull Account*)account
{
    if (self = [super init])
    {
        [self setValue:account forKey:@"account"];
    }
    
    return self;
}

@end
