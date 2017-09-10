//
//  ExchangeViewController.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeViewModel.h"

// A view controller to exchange currencies.

@interface ExchangeViewController : UIViewController

@property (nonnull, nonatomic) ExchangeViewModel* viewModel;

@end
