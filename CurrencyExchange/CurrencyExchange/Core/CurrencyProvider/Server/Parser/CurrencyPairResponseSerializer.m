//
//  CurrencyPairResponseSerializer.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 12/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CurrencyPairResponseSerializer.h"
@import XMLDictionary;

// Errors

NSString* _Nonnull const ParserErrorDomain = @"com.irudometov.errordomain.Parser";

const NSInteger kParserError_InvalidResponseFormat = 120;
const NSInteger kParserError_InvalidOpeartion = 121;

// Currency pair response serializer

@implementation CurrencyPairResponseSerializer

#pragma mark - Initialization

+ (nonnull instancetype) serializerWithBaseCurrency:(nonnull Currency*)baseCurrency
{
    return [[self alloc] initWithBaseCurrency:baseCurrency];
}

- (nonnull instancetype) initWithBaseCurrency:(nonnull Currency*)baseCurrency
{
    if (self = [super init])
    {
        _baseCurrency = baseCurrency;
    }
    
    return self;
}

#pragma mark - Parse response

- (nullable CurrencyPairResponse*) parseCurrencyPairsFromResponse:(nonnull NSObject*)response error:(NSError* _Nonnull __autoreleasing *_Nullable)error
{
    @try
    {
        NSAssert([self.baseCurrency isKindOfClass:[Currency class]], @"Base currency should be set up to parse server response.");
        
        if ([response isKindOfClass:[NSData class]])
        {
            NSDictionary* payload = [NSDictionary dictionaryWithXMLData:(NSData*)response];
            
            if ([payload isKindOfClass:[NSDictionary class]] )
            {
                // Parse rates and bulid currency pairs using the base currency.
                
                NSDictionary* cube = payload[@"Cube"][@"Cube"];
                NSString* timeString = cube[@"_time"];
                NSArray<CurrencyPair*>* pairs = [CurrencyPairResponseSerializer buildPairsFromJSON:cube[@"Cube"] baseCurrency:self.baseCurrency];

                return [CurrencyPairResponse responseWithPairs:pairs timeString:timeString];
            }
        }
        
        if (error != NULL)
        {
            const NSInteger errorCode = kParserError_InvalidResponseFormat;
            NSString* localizedDescription = [CurrencyPairResponseSerializer localizedDescriptionForErrorCode:errorCode];
            *error = [NSError errorWithDomain:ParserErrorDomain code:errorCode userInfo:@{ NSLocalizedDescriptionKey : localizedDescription }];
        }
    }
    @catch (NSException *exception)
    {
        if (error != NULL)
        {
            const NSInteger errorCode = kParserError_InvalidOpeartion;
            NSString* localizedDescription = (exception.reason != nil ? exception.reason : [CurrencyPairResponseSerializer localizedDescriptionForErrorCode:errorCode]);
            *error = [NSError errorWithDomain:ParserErrorDomain code:errorCode userInfo:@{ NSLocalizedDescriptionKey : localizedDescription }];
        }
    }
    
    return nil;
}

+ (nonnull NSArray<CurrencyPair*>*) buildPairsFromJSON:(nonnull NSArray<NSDictionary*>*)json baseCurrency:(nonnull Currency*)baseCurrency
{
    NSMutableArray<CurrencyPair*>* pairs = [NSMutableArray<CurrencyPair*> array];
    
    for (NSDictionary* payload in json)
    {
        NSString* code = payload[@"_currency"];
        NSString* rateString = payload[@"_rate"];
        
        // Make sure the use won't lost the money on an exchange operation.
        
        if (rateString.doubleValue > 0)
        {
            Currency* target = [Currency currencyWithCode:code.uppercaseString];
            CurrencyPair* pair = [CurrencyPair pairWithSource:baseCurrency target:target rate:rateString.doubleValue];
            [pairs addObject:pair];
        }
    }
    
    return pairs;
}

#pragma mark - Localized error code

+ (nonnull NSString*) localizedDescriptionForErrorCode:(NSInteger)errorCode
{
    NSString* key = nil;
    
    switch (errorCode)
    {
        case kParserError_InvalidResponseFormat:
            key = @"parser_error_invalid_response_format";
            break;
            
        case kParserError_InvalidOpeartion:
            key = @"parser_error_invalid_operation";
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
