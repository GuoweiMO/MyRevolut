//
//  BalanceManager.m
//  MyRevolut
//
//  Created by Guowei Mo on 22/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "BalanceManager.h"

#define kInitBalance @(100)

@interface BalanceManager ()

@property (nonatomic, strong) NSMutableDictionary *balanceDict;

@end

@implementation BalanceManager

+ (id)sharedManager {
  static BalanceManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (instancetype)init
{
  if(self = [super init]) {
    self.balanceDict = [NSMutableDictionary dictionaryWithObjects:@[kInitBalance, kInitBalance, kInitBalance] forKeys:@[@"GBP", @"EUR", @"USD"]];
  }
  return self;
}


-(double)balanceForCurrency:(NSString *)currency
{
  return [[self.balanceDict objectForKey:currency] doubleValue];
}

-(void)updateBalance:(double)balanceDiff forCurrency:(NSString *)currency
{
  double currentBalance = [[self.balanceDict objectForKey:currency] doubleValue];
  double newBalance = currentBalance + balanceDiff;
  [self.balanceDict setObject:@(newBalance) forKey:currency];
}

@end
