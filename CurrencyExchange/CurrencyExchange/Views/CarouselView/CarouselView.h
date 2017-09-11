//
//  CarouselView.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 10/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRecordView.h"

// Delegate

@class CarouselView;

@protocol CarouselViewDelegate <NSObject>

- (void) carouselViewDidChangePage:(nonnull CarouselView*)carouselView;

- (void) carouselView:(nonnull CarouselView*)carouselView bindRecordView:(nonnull AccountRecordView*)recordView forPage:(NSInteger)page;

@end

// A complex view to display paged scroll view.

@interface CarouselView : UIView

@property (nonatomic, readwrite) NSUInteger page;
@property (nonatomic, readwrite) NSUInteger pageCount;
@property (nonatomic, readwrite) NSArray<AccountRecordView*>* _Nonnull views;

@property (nullable, nonatomic, weak) id <CarouselViewDelegate> delegate;

@end
