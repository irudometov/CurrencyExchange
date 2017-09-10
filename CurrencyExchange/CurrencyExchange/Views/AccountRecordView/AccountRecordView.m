//
//  AccountRecordView.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountRecordView.h"

// Account record view

@implementation AccountRecordView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    if (self.amountTextField != nil)
    {
        [self subscribeForTextField:self.amountTextField];
    }
}

#pragma marmk - Notifications

- (void) subscribeForTextField:(nonnull UITextField*)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeText:) name:UITextFieldTextDidChangeNotification object:textField];
    
    textField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void) didChangeText:(nonnull NSNotification*)notification
{
    NSLog(@"text changed: '%@'", self.amountTextField.text);
}

@end
