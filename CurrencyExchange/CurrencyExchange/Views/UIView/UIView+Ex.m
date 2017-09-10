//
//  UIView+Ex.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "UIView+Ex.h"

@implementation UIView (Ex)

#pragma mark - Load From Xib

+ (nullable instancetype) loadFromNib
{
    return [self loadFromNibWithName:NSStringFromClass([self class])];
}

+ (nonnull instancetype) loadFromNib2
{
    NSString* nibName = [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] lastObject];
    
    @try
    {
        UINib* nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        
        if (nib)
        {
            id owner = [self new];
            
            NSArray* topLevelObjects = [nib instantiateWithOwner:owner options:nil];
            NSAssert(topLevelObjects.count > 0, @"Fail to instanciate a nib %@ for owner %@", nibName, self);
            
            return topLevelObjects[0];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception has occured: %@", exception);
    }
}

+ (nullable instancetype) loadFromNibWithName:(nonnull NSString*)nibName
{
    @try
    {
        UINib* nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        
        if (nib)
        {
            id owner = [self new];
            
            NSArray* topLevelObjects = [nib instantiateWithOwner:owner options:nil];
            
            if (!topLevelObjects || topLevelObjects.count == 0)
            {
                NSLog(@"Fail to instanciate nib %@ for owner %@", nib, owner);
                return nil;
            }
            
            return topLevelObjects[0];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception has occured: %@", exception);
    }
    
    return nil;
}

@end
