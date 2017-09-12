//
//  CurrencyProvider+Network.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyProvider+Network.h"
#import "CurrencyProvider+Private.h"
#import "NetworkService.h"
#import "CurrencyPairResponseSerializer.h"

// The URL of daily rates xml.

NSString* _Nonnull const kDailyStatXMLURLString = @"https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml";

// Currency provider

@implementation CurrencyProvider (Network)

+ (nonnull NSURLRequest*) buildDefaultRequest
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:kDailyStatXMLURLString]];
}

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback
{
    _callback = callback;
    
    // Cancel the previous request.
    
    if (_task != nil)
    {
        [_task cancel];
        _task = nil;
    }
    
    // And start a new one...
    
    NSURLRequest* request = [CurrencyProvider buildDefaultRequest];
    
    __weak typeof (self) this = self;
    
    _task = [[NetworkService sharedInstance] dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (this != nil)
        {
            __strong typeof (this) This = this;
            
            This->_task = nil;
            
            NSError* resultError = error;
            
            if (resultError != nil)
            {
                NSLog(@"request failed with error %@", error.localizedDescription);
            }
            else if (responseObject != nil)
            {
                // Try to parse response and get conversion rates from it.
                
                CurrencyPairResponseSerializer* parser = [CurrencyPairResponseSerializer serializerWithBaseCurrency:self.baseCurrency];
                CurrencyPairResponse* pairResponse = [parser parseCurrencyPairsFromResponse:responseObject error:&resultError];
                
                if (pairResponse != nil && pairResponse.pairs.count > 0)
                {
                    [This setNewPairs:pairResponse.pairs];
                }
            }
            
            if (This->_callback != NULL)
            {
                This->_callback(This, resultError);
            }
        }
    }];
    
    [_task resume];
}

@end
