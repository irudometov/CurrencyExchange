//
//  UIViewController+Errors.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 11/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "UIViewController+Errors.h"

@implementation UIViewController (Errors)

- (void) displayError:(nonnull NSError*)error
{
    [self showAlertWithTitle:NSLocalizedStringFromTable(@"error_alert_title", @"Errors", nil) message:error.localizedDescription];
}

- (nonnull UIAlertController*) showAlertWithTitle:(nullable NSString*)title message:(nonnull NSString*)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_action_ok", nil) style:UIAlertActionStyleDefault handler:NULL];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
    return alert;
}

@end
