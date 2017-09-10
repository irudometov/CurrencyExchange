//
//  CarouselView.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CarouselView.h"

// Carousel view

@interface CarouselView () <UIScrollViewDelegate>

@property (nullable, nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nullable, nonatomic, weak) IBOutlet UIPageControl* pageControl;

@end

@implementation CarouselView
{
    NSInteger _page;
}

#pragma mark - Page

- (NSInteger) page
{
    return _page;
}

- (void) setPage:(NSInteger)page
{
    if (_page != page)
    {
        _page = page;
        [self didChangePage];
    }
}

- (void) didChangePage
{
    NSLog(@"did change page to %ld", (long)self.page);
}

#pragma mark - Override view's methods

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.delegate = self;
    
    _page = 0;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scroll view did end decelerating...");
}

@end
