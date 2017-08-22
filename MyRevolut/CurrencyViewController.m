//
//  CurrencyViewController.m
//  MyRevolut
//
//  Created by Guowei Mo on 21/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "CurrencyViewController.h"

#define kNumOfCurrencies 3

@interface CurrencyViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation CurrencyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self configureCarousel];

  _currencies = [NSDictionary dictionaryWithObjectsAndKeys:@"£", @"GBP", @"€", @"EUR",  @"$", @"USD", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateBalanceLabel];
}

- (void)configureCarousel
{
  _currencyCarousel.delegate = self;
  _currencyCarousel.dataSource = self;
  _currencyCarousel.type = iCarouselTypeLinear;
  _currencyCarousel.pagingEnabled = YES;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
  if(option == iCarouselOptionWrap)
  {
    return YES;
  }
  return value;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
  return kNumOfCurrencies;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
  if(view == nil)
  {
    CurrencyItemView *itemView = [CurrencyItemView viewFromNib];
    itemView.frame = carousel.bounds;
    [itemView updateViewWithCurrency: [_currencies allKeys][index]];
    itemView.textFieldOutput = self;
    view = itemView;
  }
  return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
  _pageControl.currentPage = carousel.currentItemIndex;
  if([_output conformsToProtocol:@protocol(CurrencyViewControllerOutput)])
  {
    [_output currencydidChange];
  }
  CurrencyItemView *currentView = (CurrencyItemView *)self.currencyCarousel.currentItemView;
  [currentView setAmountFieldAsFirstResponder];
  [self updateBalanceLabel];
}

- (void)updateBalanceLabel
{
  _currentBalanceLabel.text = [NSString stringWithFormat:@"You have %@100", [self currentCurrencySymbol]];
}

- (double)currentAmountValue
{
  CurrencyItemView *currentView = (CurrencyItemView *)self.currencyCarousel.currentItemView;
  return [currentView amountValue];
}

- (NSString *)currentCurrency
{
  return  [_currencies allKeys][_currencyCarousel.currentItemIndex];
}

- (NSString *)currentCurrencySymbol
{
  return  [_currencies allValues][_currencyCarousel.currentItemIndex];
}

- (void)amountDidChangeToValue:(double)newValue
{
  if([_output conformsToProtocol:@protocol(CurrencyViewControllerOutput)])
  {
    [_output viewControler:self didChangeToAmount:newValue];
  }
}

- (void)updateAmountFieldToValue:(NSString *)value
{
  CurrencyItemView *currentView = (CurrencyItemView *)self.currencyCarousel.currentItemView;
  [currentView setAmountFieldToValue:value];
}

@end
