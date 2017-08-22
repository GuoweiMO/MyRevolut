//
//  QuoteCurrencyViewController.h
//  MyRevolut
//
//  Created by Guowei Mo on 21/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyViewController.h"

@interface QuoteCurrencyViewController : CurrencyViewController

- (void)updateExchangeRateLabel:(NSString *)rate;

@end
