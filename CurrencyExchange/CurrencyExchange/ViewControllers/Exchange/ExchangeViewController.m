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
