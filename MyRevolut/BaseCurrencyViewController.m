//
//  BaseCurrencyViewController.m
//  MyRevolut
//
//  Created by Guowei Mo on 21/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "BaseCurrencyViewController.h"

#define kInitBaseValue @"-1"

@interface BaseCurrencyViewController ()

@end

@implementation BaseCurrencyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self setupBaseCurrencyView];
}

- (void)setupBaseCurrencyView
{
  self.currencyCarousel.currentItemIndex = 0;
  CurrencyItemView *view = (CurrencyItemView*)self.currencyCarousel.currentItemView;
  [view setAmountFieldAsFirstResponder];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
  CurrencyItemView *itemView = (CurrencyItemView*)[super carousel:carousel viewForItemAtIndex:index reusingView:view];
  [itemView setAmountFieldToValue:kInitBaseValue];
  return itemView;
}

- (void)showBalanceWarning:(BOOL)shouldShow
{
  self.currentBalanceLabel.textColor = shouldShow ? [UIColor redColor] : [UIColor whiteColor];
}

@end
