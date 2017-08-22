//
//  ExchangeRateConnection.h
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLDictionary.h"
#import "ExchangeRate.h"

typedef void (^exchangeRateHandler)(ExchangeRate * rateData);

@interface ExchangeRateConnection : NSObject

@property(nonatomic, strong) ExchangeRate *rateData;

- (void)requestExchangeRateWithURL:(NSString *)urlString completed:(exchangeRateHandler)handler;

@end
