//
//  CarouselView.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate

@class CarouselView;

@protocol CarouselViewDelegate <NSObject>

- (void) carouselViewDidChangePage:(nonnull CarouselView*)carouselView;

@end

// A complex view to display paged scroll view.

@interface CarouselView : UIView

@property (nonatomic, readwrite) NSUInteger page;
@property (nonatomic, readwrite) NSUInteger pageCount;
@property (nonatomic, readwrite) NSArray<UIView*>* _Nonnull views;

@property (nullable, nonatomic, weak) id <CarouselViewDelegate> delegate;

@end
