//
//  AccountViewController.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountViewModel.h"
#import "AccountRecordTableViewCell.h"
#import "ExchangeViewController.h"
#import "AccountViewModel+DefaultAccount.h"
#import "CurrencyProvider+Network.h"

static NSString* _Nonnull const kAccountRecordCellId = @"account-record";
static NSString* _Nonnull const kSeque_OpenExchange = @"open-exchange";

// Account view controller

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonnull, nonatomic) AccountViewModel* viewModel;
@property (nonnull, nonatomic) IBOutlet UITableView* tableView;
@property (nonnull, nonatomic) IBOutlet UIButton* exchangeButton;

@end

@implementation AccountViewController

+ (nullable instancetype) viewControllerForAccount:(nonnull Account*)account
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AccountViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    
    if ([viewController isKindOfClass:[AccountViewController class]])
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
    [self congiureExchangeButton];
    
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Load currency rates from the server on the first appear.
    
    [[CurrencyProvider sharedInstance] startRefreshingPairs];
}

#pragma mark - Configure

- (void) congiureTableView:(nonnull UITableView*)tableView
{
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void) congiureExchangeButton
{
    self.exchangeButton.layer.cornerRadius = 5;
    self.exchangeButton.layer.masksToBounds = YES;
}

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
    if ([segue.identifier isEqualToString:kSeque_OpenExchange] &&
        [segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* navigationController = (UINavigationController*)segue.destinationViewController;
        ExchangeViewController* viewController = (ExchangeViewController*)navigationController.viewControllers.firstObject;
        viewController.viewModel = [ExchangeViewModel viewModelForAccount:self.viewModel.account];
    }
}

@end
