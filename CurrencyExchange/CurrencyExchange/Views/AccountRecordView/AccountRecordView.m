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

#pragma mark - init / deinit

- (void) dealloc
{
    if (self.amountTextField != nil)
    {
        [self unsubscribeFromTextField:self.amountTextField];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override view's methods

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    if (self.amountTextField != nil)
    {
        [self subscribeForTextField:self.amountTextField];
        self.amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

#pragma marmk - Notifications

- (void) subscribeForTextField:(nonnull UITextField*)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeText:) name:UITextFieldTextDidChangeNotification object:textField];
    
    textField.delegate = self;
}

- (void) unsubscribeFromTextField:(nonnull UITextField*)textField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
    
    if (textField.delegate == self)
    {
        textField.delegate = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"did begin editing with text '%@'", textField.text);
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"did end editing with text '%@'", textField.text);
}

- (void) didChangeText:(nonnull NSNotification*)notification
{
    if ([self.delegate respondsToSelector:@selector(acountRecordViewDidChangeInput:)])
    {
        [self.delegate acountRecordViewDidChangeInput:self];
    }
}

@end
