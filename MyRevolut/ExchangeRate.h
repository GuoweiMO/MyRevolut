//
//  ExchangeRate.h
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExchangeRate : NSObject

- (instancetype)initWithData:(NSDictionary *)data;

- (double) rateOfQuote:(NSString *)quote basedOn:(NSString *)base;

@end
