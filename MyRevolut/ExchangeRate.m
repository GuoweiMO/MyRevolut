//
//  ExchangeRate.m
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "ExchangeRate.h"

@interface ExchangeRate ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *rates;

@end

@implementation ExchangeRate

- (instancetype)initWithData:(NSDictionary *)data
{
  self = [super init];
  if (self) {
    
    _rates = [[NSMutableDictionary alloc] init];
    
    NSArray *rates = (NSArray *) [data valueForKeyPath:@"Cube.Cube.Cube"];
    
    if(rates != nil)
    {
      _rates[@"EUR"] = @(1.0);
      [rates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *rateDict = obj;
        _rates[[rateDict valueForKey:@"_currency"]] = [rateDict valueForKey: @"_rate"];
      }];
    }
  }
  return self;
}

- (double) rateOfQuote:(NSString *)quote basedOn:(NSString *)base
{
  if([quote isEqualToString:base])
    return 1.0;
  
  double quoteBasedOnEUR = [[_rates valueForKey:quote] doubleValue];
  double baseBasedOnEUR = [[_rates valueForKey:base] doubleValue];
  
  if(baseBasedOnEUR == 0) return 0;
  
  return quoteBasedOnEUR / baseBasedOnEUR;
}

@end
