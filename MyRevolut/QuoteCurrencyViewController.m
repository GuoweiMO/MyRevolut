//
//  QuoteCurrencyViewController.m
//  MyRevolut
//
//  Created by Guowei Mo on 21/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "QuoteCurrencyViewController.h"

@interface QuoteCurrencyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel;

@end

@implementation QuoteCurrencyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  self.currencyCarousel.currentItemIndex = 1;
}

- (void)updateExchangeRateLabel:(NSString *)rate
{
  _exchangeRateLabel.text = rate;
}

@end
