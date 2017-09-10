//
//  AccountRecordTableViewCell.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountRecordTableViewCell.h"

// Account record table view cell

@implementation AccountRecordTableViewCell

- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) reset
{
    self.currencyCodeLabel.text = nil;
    self.amountLabel.text = nil;
}

@end
