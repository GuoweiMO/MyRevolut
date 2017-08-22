//
//  ViewController.m
//  MyRevolut
//
//  Created by Guowei Mo on 16/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "HomeViewController.h"
#import "ExchangeRateConnection.h"

#define kExchangeRatesURL @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
#define kInitBalance 100
#define kBaseCurrencyFormat @"-%.02f"
#define kQuoteCurrencyFormat @"+%.02f"
#define kHeaderRateFormat @"%@1=%@%.04f"
#define kQuoteRateFormat @"%@1=%@%.02f"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentRateLabel;

@property(strong, nonatomic) BaseCurrencyViewController *baseCurrencyVC;

@property(strong, nonatomic) QuoteCurrencyViewController *quoteCurrencyVC;

@property(strong, nonatomic) ExchangeRate *rateData;

@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _baseCurrencyVC = self.childViewControllers[0];
  _baseCurrencyVC.output = self;
  _quoteCurrencyVC = self.childViewControllers[1];
  _quoteCurrencyVC.output = self;
  
  [self requestCurrencyRateOnLoad];
}

-(void)requestCurrencyRateOnLoad
{
  [self fetchExchangeRate];
  [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
    [self fetchExchangeRate];
  }];
}

- (void)fetchExchangeRate
{
  [[ExchangeRateConnection new] requestExchangeRateWithURL:kExchangeRatesURL completed:^(ExchangeRate *rateData) {
    _rateData = rateData;
    [self updateRateHeaderLabel];
    [self updateQuoteValue];
  }];
}

- (void)currencydidChange
{
  [self updateRateHeaderLabel];
  [self updateQuoteValue];
  [_baseCurrencyVC showBalanceWarning:NO];
}

- (void)viewControler:(CurrencyViewController *)viewController didChangeToAmount:(double)newValue
{
  [_baseCurrencyVC showBalanceWarning:NO];
  if([viewController isKindOfClass:[BaseCurrencyViewController class]])
  {
    double newQuote = newValue * [self currentRate];
    [_quoteCurrencyVC updateAmountFieldToValue:[NSString stringWithFormat:kQuoteCurrencyFormat, newQuote]];
    if(newValue > kInitBalance)
    {
      [_baseCurrencyVC showBalanceWarning:YES];
    }
  }
  else if([viewController isKindOfClass:[QuoteCurrencyViewController class]])
  {
    double newBase = newValue / [self currentRate];
    [_baseCurrencyVC updateAmountFieldToValue:[NSString stringWithFormat:kBaseCurrencyFormat, newBase]];
    if(newBase > kInitBalance)
    {
      [_baseCurrencyVC showBalanceWarning:YES];
    }
  }
}

- (void)updateRateHeaderLabel
{
  _currentRateLabel.text = [NSString stringWithFormat:kHeaderRateFormat,
                            [_baseCurrencyVC currentCurrencySymbol],
                            [_quoteCurrencyVC currentCurrencySymbol],
                            [self currentRate]];
}

- (void)updateQuoteValue
{
  double baseValue = [_baseCurrencyVC currentAmountValue];
  double rate = [self currentRate];
  double newQuote = baseValue * rate;
  [_quoteCurrencyVC updateAmountFieldToValue:[NSString stringWithFormat:kQuoteCurrencyFormat, newQuote]];
  
  NSString *rateString = [NSString stringWithFormat:kQuoteRateFormat,
                          [_quoteCurrencyVC currentCurrencySymbol],
                          [_baseCurrencyVC currentCurrencySymbol],
                          1 / rate];
  
  [_quoteCurrencyVC updateExchangeRateLabel:rateString];
}

- (double)currentRate
{
  NSString *baseCurrency = [_baseCurrencyVC currentCurrency];
  NSString *quoteCurrency = [_quoteCurrencyVC currentCurrency];
  return ABS([_rateData rateOfQuote:quoteCurrency basedOn:baseCurrency]);
}

- (IBAction)performExchangeAction:(id)sender {
  
}

@end
