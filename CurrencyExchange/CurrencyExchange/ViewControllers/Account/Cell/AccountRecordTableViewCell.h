//
//  AccountRecordTableViewCell.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>

// A table view cell to display a single account record.

@interface AccountRecordTableViewCell : UITableViewCell

@property (nullable, nonatomic, weak) IBOutlet UILabel* currencyCodeLabel;
@property (nullable, nonatomic, weak) IBOutlet UILabel* amountLabel;

@end
