//
//  ViewController.m
//  MyRevolut
//
//  Created by Guowei Mo on 16/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "HomeViewController.h"
#import "ExchangeRateConnection.h"
#import "BalanceManager.h"

#define kExchangeRatesURL @"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
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
  
  [self updateBalanceIfNeeded];
  [self requestCurrencyRateOnLoad];
}

-(void)requestCurrencyRateOnLoad
{
  [self fetchExchangeRate];
  [NSTimer scheduledTimerWithTimeInterval:30 repeats:YES block:^(NSTimer * _Nonnull timer) {
    [self fetchExchangeRate];
  }];
}

- (void)fetchExchangeRate
{
  [[ExchangeRateConnection new] requestExchangeRateWithURL:kExchangeRatesURL completed:^(ExchangeRate *rateData) {
    _rateData = rateData;
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateRateHeaderLabel];
      [self updateQuoteValue];
    });
  }];
}

- (void)currencydidChange
{
  [self updateRateHeaderLabel];
  [self updateQuoteValue];
  [_baseCurrencyVC showBalanceWarning:NO];
  [self updateBalanceIfNeeded];
}

- (void)viewControler:(CurrencyViewController *)viewController didChangeToAmount:(double)newValue
{
  [_baseCurrencyVC showBalanceWarning:NO];
  double newBaseValue = 0;
  if([viewController isKindOfClass:[BaseCurrencyViewController class]])
  {
    double newQuote = newValue * [self currentRate];
    [_quoteCurrencyVC updateAmountFieldToValue:[NSString stringWithFormat:kQuoteCurrencyFormat, newQuote]];
    
    newBaseValue = newValue;
  }
  else if([viewController isKindOfClass:[QuoteCurrencyViewController class]])
  {
    double newBase = newValue / [self currentRate];
    [_baseCurrencyVC updateAmountFieldToValue:[NSString stringWithFormat:kBaseCurrencyFormat, newBase]];
    newBaseValue = newBase;
  }
  
  if(newValue > [self currentBaseBalance])
  {
    [_baseCurrencyVC showBalanceWarning:YES];
  }
}

- (double)currentBaseBalance
{
  return [[BalanceManager sharedManager] balanceForCurrency:[_baseCurrencyVC currentCurrency]];
}

- (double)currentQuoteBalance
{
  return [[BalanceManager sharedManager] balanceForCurrency:[_quoteCurrencyVC currentCurrency]];
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

- (IBAction)exchangeButtonDidTap:(id)sender {
   if([_baseCurrencyVC currentAmountValue] > [self currentBaseBalance])
   {
     [self showInsufficientBalanceAlert];
   }
  else
  {
    [self performExchangeAction];
  }
}

- (void)performExchangeAction
{
  double valueOut = -1 * [_baseCurrencyVC currentAmountValue];
  [[BalanceManager sharedManager] updateBalance:valueOut forCurrency:[_baseCurrencyVC currentCurrency]];
  
  double valueIn = [_quoteCurrencyVC currentAmountValue];
  [[BalanceManager sharedManager] updateBalance:valueIn forCurrency:[_quoteCurrencyVC currentCurrency]];
  
  __weak typeof(self) weakSelf = self;
  [self showExchangeInProgressAlertCompleted:^{
    [weakSelf resetBaseAmount];
    [weakSelf updateBalanceIfNeeded];
  }];
}

- (void)updateBalanceIfNeeded
{
  [_baseCurrencyVC updateBalanceLabelWithBalance:[self currentBaseBalance]];
  [_quoteCurrencyVC updateBalanceLabelWithBalance:[self currentQuoteBalance]];
}

- (void)resetBaseAmount
{
  [_baseCurrencyVC reloadView];
}

- (void)showExchangeInProgressAlertCompleted:(void (^ __nullable)(void))completionHandler
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"Exchange is in progress. please wait ..." preferredStyle:UIAlertControllerStyleAlert];
  [self presentViewController:alert animated:YES completion:^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [alert dismissViewControllerAnimated:YES completion:nil];
      completionHandler();
    });
  }];
}

- (void)showInsufficientBalanceAlert
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You don't have sufficient balance to finish exchange. Please top up or try lower amount." preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    [alert dismissViewControllerAnimated:YES completion:nil];
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"Top up" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  }]];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
