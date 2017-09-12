//
//  NetworkService.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AFNetworking;

// A service to work with the server.

@interface NetworkService : AFHTTPSessionManager

+ (nonnull instancetype) sharedInstance;

@end
