//
//  UIViewController+Errors.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>

// An extension of view controller to display alerts and errors.

@interface UIViewController (Errors)

- (void) displayError:(nonnull NSError*)error;

- (nonnull UIAlertController*) showAlertWithTitle:(nullable NSString*)title message:(nonnull NSString*)message;

@end
