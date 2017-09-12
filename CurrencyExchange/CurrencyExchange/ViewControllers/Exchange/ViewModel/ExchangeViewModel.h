//
//  ExchangeViewModel.h
//  CurrencyExchange
//
//  Created by Ilya Rudometov on 09/09/2017.
//  Copyright © 2017 Ilya Rudometov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountViewModel.h"

// View model presenter

@protocol IViewModelPresenter <NSObject>

- (void) viewModelDidUpdate:(nonnull NSObject*)viewModel;

@end

// A view model to exchange currencies.

@interface ExchangeViewModel : AccountViewModel

@property (nullable, nonatomic, weak) id <IViewModelPresenter> presenter;

@property (nonatomic, readwrite) double unitsToExchange;

@property (nonatomic) NSUInteger sourceRecordIndex;
@property (nonatomic) NSUInteger targetRecordIndex;

@property (nonnull, nonatomic, readonly) AccountRecord* sourceRecord;
@property (nonnull, nonatomic, readonly) AccountRecord* targetRecord;

- (nullable NSNumber*) unitsToExchangeInCurrency:(nonnull Currency*)currency;

- (nonnull Currency*) sourceCurrencyAtIndex:(NSInteger)index;
- (nonnull Currency*) destinationCurrencyAtIndex:(NSInteger)index;

// Balance

- (double) balanceForRecortAtIndex:(NSInteger)index;
- (BOOL) hasEnoughMoneyForRecordAtIndex:(NSInteger)index;

// Localization

- (nonnull NSString*) localizedBalanceForRecordAtIndex:(NSInteger)index checkEnoughMoney:(BOOL)checkEnoughMoney;
+ (nonnull NSString*) localizedBalanceForRecord:(nonnull AccountRecord*)record enough:(BOOL)enough;
+ (nonnull NSString*) localizedRateFrom:(nonnull Currency*)source to:(nonnull Currency*)target;
- (nonnull NSString*) localizedRate;

// A basic mechanism to exchange currencies between 2 records.

- (BOOL) exchange:(NSError* _Nonnull __autoreleasing *_Nullable)error;

@end
