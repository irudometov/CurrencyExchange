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

const NSTimeInterval CURRENCY_REFRESH_TIME_INTERVAL = 30; // sec

// Currency provider

@implementation CurrencyProvider (Network)

+ (nonnull NSURLRequest*) buildDefaultRequest
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:kDailyStatXMLURLString]];
}

- (void) refreshCurrenciesWithCompletion:(nonnull CurrencyProviderCallback)callback
{
    _callback = callback;
    [self refreshCurrencies];
}

- (void) refreshCurrencies
{
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
                CurrencyProviderCallback block = This->_callback;
                This->_callback = NULL;
                block(This, resultError);
            }
            
            if (This->_isRefreshing)
            {
                [This scheduleTimer];
            }
        }
    }];
    
    [_task resume];
}

#pragma mark - Timer

- (void) startRefreshingPairs
{
    _isRefreshing = YES;
    [self subscribeForApplicationNotifications];
    [self refreshCurrencies];
}

- (void) stopRefreshingPairs
{
    _isRefreshing = NO;
    [self invalidateTimer];
}

- (void) scheduleTimer
{
    // Invalidate the current timer and setup a new one...
    
    [self invalidateTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:CURRENCY_REFRESH_TIME_INTERVAL target:self selector:@selector(refreshCurrencies) userInfo:nil repeats:NO];
}

- (void) invalidateTimer
{
    if (_timer != nil)
    {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        
        _timer = nil;
    }
}

#pragma mark - App notifications

- (void) subscribeForApplicationNotifications
{
    [self unsubscribeFromApplicationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefreshingPairs) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefreshingPairs) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

- (void) unsubscribeFromApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

@end
