//
//  CarouselView.m
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import "CarouselView.h"
#import "AccountRecordView.h"
#import "UIView+Ex.h"

static const NSInteger PAGE_SPREAD = 1000;
static const NSInteger VIEWS_COUNT = 3; // One visible at the momen and plus left and right views.
static const CGFloat BOTTOM_PADDING = 24; // px

// Carousel view

@interface CarouselView () <UIScrollViewDelegate>

@property (nullable, nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nullable, nonatomic, weak) IBOutlet UIPageControl* pageControl;

@end

@implementation CarouselView
{
    NSInteger _internalPage;
    NSInteger _pageCount;
    NSMutableArray<AccountRecordView*>* _views;
}

#pragma mark - init / deinit

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _views = [NSMutableArray<AccountRecordView*> new];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        _views = [NSMutableArray<AccountRecordView*> new];
    }
    
    return self;
}

#pragma mark - Override view's methods

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
    
    _internalPage = PAGE_SPREAD;
    _pageCount = 0;
}

#pragma mark - Page count

- (NSUInteger) pageCount
{
    return _pageCount;
}

- (void) setPageCount:(NSUInteger)pageCount
{
    if (_pageCount != pageCount)
    {
        _pageCount = pageCount;
        [self adjustViewsCount];
    }
}

- (void) adjustViewsCount
{
    // Remove extra views.
    
    if (VIEWS_COUNT < _views.count)
    {
        for (NSInteger i = _views.count - 1; i >= VIEWS_COUNT; --i)
        {
            UIView* view = _views[i];
            [view removeFromSuperview];
        }
    }
    
    // Create requried views.
    
    for (NSInteger i = _views.count; i < VIEWS_COUNT; ++i)
    {
        AccountRecordView* view = [AccountRecordView loadFromNib];
        [_views addObject:view];
        [self.scrollView addSubview:view];
    }
    
    [self adjustFrames];
}

#pragma mark - Page

- (NSUInteger) page
{
    return (_internalPage % self.pageCount);
}

- (void) setPage:(NSUInteger)page
{
    if (_internalPage != page)
    {
        _internalPage = (page % self.pageCount) + PAGE_SPREAD - (PAGE_SPREAD % self.pageCount);
        [self didChangePage];
    }
}

- (void) didChangePage
{
    [self adjustContentSize];
    [self adjustContentOffset];
    [self adjustFrames];
    
    self.pageControl.currentPage = self.page;
    
    if ([self.delegate respondsToSelector:@selector(carouselViewDidChangePage:)])
    {
        [self.delegate carouselViewDidChangePage:self];
    }
}

#pragma mark - Subscribe for frame changes

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self adjustFrames];
}

- (void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self adjustFrames];
}

#pragma mark - Manage views

- (nonnull NSArray<UIView*>*)views
{
    return _views;
}

- (void) adjustFrames
{
    if (self.views.count > 0)
    {
        CGRect frame = self.scrollView.frame;
        frame.size = CGSizeMake(self.bounds.size.width, MAX(self.bounds.size.height - BOTTOM_PADDING, 0));
        self.scrollView.frame = frame;
        
        [self adjustContentSize];
        [self adjustContentOffset];
        
        [self adjustViewForPage:_internalPage - 1];
        [self adjustViewForPage:_internalPage];
        [self adjustViewForPage:_internalPage + 1];
    }
}

- (void) adjustViewForPage:(NSInteger)page
{
    const NSInteger index = [self viewIndexForPage:page];
    UIView* view = self.views[index];
    view.frame = [self frameForPage:page];
}

- (NSInteger) viewIndexForPage:(NSInteger)page
{
    const NSInteger viewsCount = self.views.count;
    
    if (page >= 0)
    {
        return page % viewsCount;
    }
    
    return labs(labs(page) % viewsCount - viewsCount) % viewsCount;
}

- (CGPoint) offsetForPage:(NSInteger)page
{
    return CGPointMake(page * self.scrollView.bounds.size.width, 0);
}

- (CGRect) frameForPage:(NSInteger)page
{
    CGRect frame = CGRectZero;
    
    frame.origin = [self offsetForPage:page];
    frame.size = _scrollView.bounds.size;
    
    return frame;
}

- (void) adjustContentOffset
{
    self.scrollView.contentOffset = [self offsetForPage:_internalPage];
}

- (void) adjustContentSize
{
    const NSInteger totalPageCount = PAGE_SPREAD * 2;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * totalPageCount, self.bounds.size.height);
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Lock Y axis to 0.
    
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.y = 0;
    scrollView.contentOffset = contentOffset;
}

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
