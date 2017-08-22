//
//  CurrencyViewController.h
//  MyRevolut
//
//  Created by Guowei Mo on 21/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>
#import "CurrencyItemView.h"

@class CurrencyViewController;

@protocol CurrencyViewControllerOutput <NSObject>

- (void)currencydidChange;
- (void)viewControler:(CurrencyViewController *)viewController didChangeToAmount:(double)newValue;

@end


@interface CurrencyViewController : UIViewController<iCarouselDelegate, iCarouselDataSource, CurrencyAmountLabelOutput>

@property (weak, nonatomic) IBOutlet UILabel *currentBalanceLabel;
@property (weak, nonatomic) IBOutlet iCarousel *currencyCarousel;
@property (strong, nonatomic, readonly) NSDictionary *currencies;
@property (weak, nonatomic) id<CurrencyViewControllerOutput> output;

- (NSString *)currentCurrency;
- (NSString *)currentCurrencySymbol;
- (double)currentAmountValue;
- (void)updateAmountFieldToValue:(NSString *)value;

@end


