//
//  NetworkService.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "NetworkService.h"
@import AFNetworking;

static NSString* _Nonnull const kContentType_TextXML = @"text/xml";

// Network service

@implementation NetworkService

+ (nonnull instancetype) sharedInstance
{
    static NetworkService* __sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [self manager];
    });
    
    return __sharedInstance;
}

#pragma mark - Initialization

- (id) initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration])
    {
        [self configureSessionManager];
    }
    
    return self;
}

- (void) configureSessionManager
{
    // Make sure we can accept xml responses.
    
    self.responseSerializer = [AFHTTPResponseSerializer new];
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:kContentType_TextXML];
}

@end
