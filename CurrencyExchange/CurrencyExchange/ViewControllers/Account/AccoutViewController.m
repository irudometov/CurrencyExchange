//
//  AccoutViewController.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccoutViewController.h"
#import "AccountViewModel.h"
#import "AccountRecordTableViewCell.h"
#import "ExchangeViewController.h"
#import "AccountViewModel+DefaultAccount.h"

static NSString* _Nonnull const kAccountRecordCellId = @"account-record";

// Account view controller

@interface AccoutViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic) AccountViewModel* viewModel;
@property (nonnull, nonatomic) IBOutlet UITableView* tableView;

@end

@implementation AccoutViewController

+ (nullable instancetype) viewControllerForAccount:(nonnull Account*)account
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AccoutViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    
    if ([viewController isKindOfClass:[AccoutViewController class]])
    {
        viewController.viewModel = [AccountViewModel viewModelForAccount:account];
        return viewController;
    }
    
    return nil;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self congiureTableView:self.tableView];
    
    if (self.viewModel == nil)
    {
        self.viewModel = [AccountViewModel defaultAccountViewModel];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Configure

- (void) congiureTableView:(nonnull UITableView*)tableView
{
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - UITableViewDelegate

// ...

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.viewModel.numberOfRecords;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    AccountRecordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kAccountRecordCellId forIndexPath:indexPath];
    
    AccountRecord* record = [self.viewModel recordAtIndex:indexPath.row];
    
    cell.currencyCodeLabel.text = record.currency.code;
    cell.amountLabel.text = record.localizedAmountString;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"seque: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"open-exchange"] &&
        [segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)segue.destinationViewController;
        ExchangeViewController* viewController = (ExchangeViewController*)navigationController.viewControllers.firstObject;
        viewController.viewModel = [ExchangeViewModel viewModelForAccount:self.viewModel.account];
    }
}

@end
