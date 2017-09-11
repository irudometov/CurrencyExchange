//
//  ExchangeViewController.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "ExchangeViewController.h"
#import "CarouselView.h"
#import "AccountRecordView.h"
#import "CurrencyProvider.h"
#import "UIView+Ex.h"
#import "Utils.h"

// Exchange view controller

@interface ExchangeViewController () <CarouselViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton* exchangeButton;
@property (nonatomic, weak) IBOutlet UIView* sourcePlaceholder;
@property (nonatomic, weak) IBOutlet UIView* destinationPlaceholder;

@end

@implementation ExchangeViewController
{
    CarouselView* _sourceCarousel;
    CarouselView* _destinationCarousel;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self adjustFrames];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bindData];
}

#pragma mark - Bind data

- (void) bindData
{
    [_sourceCarousel bindData];
    [_destinationCarousel bindData];
    [self updateExchangeButton];
}

#pragma mark - Setup views

+ (nullable CarouselView*) createCarouselWithSize:(NSUInteger)size
{
    CarouselView* carousel = [CarouselView loadFromNib];
    
    carousel.pageCount = size;
    
    return carousel;
}

- (void) setupViews
{
    // Source carousel
    
    _sourceCarousel = [ExchangeViewController createCarouselWithSize:self.viewModel.numberOfRecords];
    _sourceCarousel.frame = self.sourcePlaceholder.bounds;
    _sourceCarousel.delegate = self;
    [self.sourcePlaceholder addSubview:_sourceCarousel];
    
    // Destination carousel
    
    _destinationCarousel = [ExchangeViewController createCarouselWithSize:self.viewModel.numberOfRecords];
    _destinationCarousel.frame = self.destinationPlaceholder.bounds;
    _destinationCarousel.delegate = self;
    [self.destinationPlaceholder addSubview:_destinationCarousel];
}

- (void) adjustFrames
{
    _sourceCarousel.frame = self.sourcePlaceholder.bounds;
    _destinationCarousel.frame = self.destinationPlaceholder.bounds;
}

#pragma mark - CarouselViewDelegate

- (void) carouselViewDidChangePage:(nonnull CarouselView*)carouselView
{
    if (carouselView == _sourceCarousel)
    {
        NSLog(@"source page is %ld", (long)carouselView.page);
        self.viewModel.sourceRecordIndex = carouselView.page;
    }
    else if (carouselView == _destinationCarousel)
    {
        NSLog(@"destination page is %ld", (long)carouselView.page);
        self.viewModel.targetRecordIndex = carouselView.page;
    }
    
    [self updateExchangeButton];
}

- (void) carouselView:(nonnull CarouselView*)carouselView bindRecordView:(nonnull AccountRecordView*)recordView forPage:(NSInteger)page
{
    AccountRecord* record = [self.viewModel recordAtIndex:page];
    
    recordView.currencyCodeLabel.text = record.currency.code;
    recordView.errorLabel.text = nil;
    
    // Display the amount to exchange for the current currency.
    
    Currency* currency = [self.viewModel currencyAtIndex:page];
    NSNumber* units = [self.viewModel unitsToExchangeInCurrency:currency];
    
    if (recordView.amountTextField.isFirstResponder == NO)
    {
        recordView.amountTextField.text = [Utils stringFromAmount:units];
    }
    
    // Display a warning message if the user doesn't have enough money to exchange.
    
    if (carouselView == _sourceCarousel && ![self.viewModel hasEnoughMoneyForRecordAtIndex:page])
    {
        recordView.currentAmountLabel.textColor = [UIColor redColor];
        recordView.currentAmountLabel.text = [NSString stringWithFormat:@"You only have %.2f", record.amount];
    }
    else
    {
        recordView.currentAmountLabel.textColor = [UIColor lightGrayColor];
        recordView.currentAmountLabel.text = [NSString stringWithFormat:@"You have %.2f", record.amount];
    }
}

- (void) carouselView:(nonnull CarouselView*)carouselView didChangeInput:(nonnull AccountRecordView*)recordView forPage:(NSInteger)page
{
    // Calculate a new amount to convert using an appropriate currency.
    
    const BOOL isSource = (carouselView == _sourceCarousel);
    Currency* currency = [self.viewModel currencyAtIndex:page];
    
    NSNumber* amount = [Utils amountFromString:recordView.amountTextField.text];
    NSNumber* unitsToExchange = [[CurrencyProvider sharedInstance] unitsFromAmount:amount.doubleValue forCurrency:currency];
    NSLog(@"source: %@, amount = %@, units = %@", @(isSource), amount, unitsToExchange);

    // Set new value and refresh views.
    
    if (unitsToExchange != nil)
    {
        self.viewModel.unitsToExchange = unitsToExchange.doubleValue;
        [self bindData];
    }
}

#pragma mark - Exchange button

- (void) updateExchangeButton
{
    // Block exchange operation if the amount to exchange is not enough
    // or the source and target records are the same.
    
    AccountRecord* source = [self.viewModel sourceRecord];
    AccountRecord* target = [self.viewModel targetRecord];
    
    const BOOL theSameCurrency = [source.currency isEqual:target.currency];
    const BOOL hasEnoughMoney = [self.viewModel hasEnoughMoneyForRecordAtIndex:self.viewModel.sourceRecordIndex];
    const BOOL hasInput = self.viewModel.unitsToExchange > 0.01;
    const BOOL allowExchangeOperation = (!theSameCurrency && hasInput && hasEnoughMoney);
    
    self.exchangeButton.enabled = allowExchangeOperation;
}

#pragma mark - Actions

- (IBAction) cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) exchange:(id)sender
{
    AccountRecord* source = [self.viewModel sourceRecord];
    AccountRecord* target = [self.viewModel targetRecord];
    
    NSLog(@"exchange %.2f EUR from %@ to %@", self.viewModel.unitsToExchange, source.currency.code, target.currency.code);
}

@end
