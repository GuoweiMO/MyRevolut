//
//  BalanceManager.h
//  MyRevolut
//
//  Created by Guowei Mo on 22/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceManager : NSObject

+ (id)sharedManager;

-(double)balanceForCurrency:(NSString *)currency;
-(void)updateBalance:(double)balanceDiff forCurrency:(NSString *)currency;

@end
