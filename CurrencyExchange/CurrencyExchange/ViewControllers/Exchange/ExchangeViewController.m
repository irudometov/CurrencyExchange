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
#import "UIView+Ex.h"
#import "CurrencyProvider.h"

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
    }
    else if (carouselView == _destinationCarousel)
    {
        NSLog(@"destination page is %ld", (long)carouselView.page);
    }
}

- (void) carouselView:(nonnull CarouselView*)carouselView bindRecordView:(nonnull AccountRecordView*)recordView forPage:(NSInteger)page
{
    AccountRecord* record = [self.viewModel recordAtIndex:page];
    
    recordView.currencyCodeLabel.text = record.currency.code;
    recordView.currentAmountLabel.text = [NSString stringWithFormat:@"You have %.2f", record.amount];
    recordView.amountTextField.text = @"1";
    recordView.errorLabel.text = nil;
}

#pragma mark - Actions

- (IBAction) cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) exchange:(id)sender
{
    NSNumber* eur = [[CurrencyProvider sharedInstance] conversionRateForCurrency:[Currency EUR]];
    NSNumber* usd = [[CurrencyProvider sharedInstance] conversionRateForCurrency:[Currency USD]];
    NSNumber* gbp = [[CurrencyProvider sharedInstance] conversionRateForCurrency:[Currency GBP]];
    NSNumber* usd_gbp = [[CurrencyProvider sharedInstance] conversionRateFrom:[Currency USD] to:[Currency GBP]];
    NSNumber* gbp_usd = [[CurrencyProvider sharedInstance] conversionRateFrom:[Currency GBP] to:[Currency USD]];
    
    NSLog(@"eur: %@", eur);
    NSLog(@"usd: %@", usd);
    NSLog(@"gbp: %@", gbp);
    NSLog(@"usd_gbp: %@", usd_gbp);
    NSLog(@"gbp_usd: %@", gbp_usd);
    
    [self.viewModel exchange:10
                  fromRecord:self.viewModel.sourceRecord
                    toRecord:self.viewModel.destinationRecord];
}

@end
