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

// Exchange view controller

@interface ExchangeViewController ()

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

- (void) setupViews
{
    // Load 2 carousel views for source and destinations account records.
    
    // Source carousel view
    
    _sourceCarousel = [CarouselView loadFromNib];
    _sourceCarousel.frame = self.sourcePlaceholder.bounds;
    [self.sourcePlaceholder addSubview:_sourceCarousel];
    
    // Destination carousel view
    
    _destinationCarousel = [CarouselView loadFromNib];
    _destinationCarousel.frame = self.destinationPlaceholder.bounds;
    [self.destinationPlaceholder addSubview:_destinationCarousel];
}

- (void) adjustFrames
{
    _sourceCarousel.frame = self.sourcePlaceholder.bounds;
    _destinationCarousel.frame = self.destinationPlaceholder.bounds;
}

#pragma mark - Actions

- (IBAction) cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) exchange:(id)sender
{
    [self.viewModel exchange:10
                  fromRecord:self.viewModel.sourceRecord
                    toRecord:self.viewModel.destinationRecord];
}

@end
