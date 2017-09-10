//
//  AccountRecordView.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountRecordViewDelegate <NSObject>



@end

// A view to display account record on carousel.

@interface AccountRecordView : UIView <UITextFieldDelegate>

@property (nullable, nonatomic, weak) IBOutlet UILabel* currencyCodeLabel;
@property (nullable, nonatomic, weak) IBOutlet UILabel* currentAmountLabel;
@property (nullable, nonatomic, weak) IBOutlet UITextField* amountTextField;
@property (nullable, nonatomic, weak) IBOutlet UILabel* errorLabel;

@property (nullable, nonatomic, weak) id <AccountRecordViewDelegate> delegate;

@end
