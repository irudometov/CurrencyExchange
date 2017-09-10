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
    NSMutableArray<UIView*>* _views;
}

#pragma mark - init / deinit

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _views = [NSMutableArray<UIView*> new];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        _views = [NSMutableArray<UIView*> new];
    }
    
    return self;
}

#pragma mark - Override view's methods

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
    
    _page = 0;
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
    if ([self.delegate respondsToSelector:@selector(carouselViewDidChangePage:)])
    {
        [self.delegate carouselViewDidChangePage:self];
    }
}

#pragma mark - Manage views

- (nonnull NSArray<UIView*>*)views
{
    return _views;
}

- (void) addView:(nonnull UIView*)view
{
    if (![_views containsObject:view])
    {
        [_views addObject:view];
        [self.scrollView addSubview:view];
        [self adjustFrames];
    }
}

- (void) adjustFrames
{
    for (NSInteger page = 0; page < self.views.count; ++page)
    {
        UIView* view = self.views[page];
        view.frame = [self frameForPage:page];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.views.count * self.bounds.size.width, self.bounds.size.height);
}

- (CGRect) frameForPage:(NSInteger)page
{
    return CGRectMake(page * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self recalculateCurrentPage];
}

- (void) recalculateCurrentPage
{
    if (self.scrollView.bounds.size.width > 0)
    {
        self.page = (self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    }
}

@end
