//
//  ExchangeRateConnection.m
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "ExchangeRateConnection.h"

@implementation ExchangeRateConnection

- (void)requestExchangeRateWithURL:(NSString *)urlString completed:(exchangeRateHandler)handler
{
  NSURL *url = [NSURL URLWithString:urlString];
  NSString *xmlString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
  NSDictionary *xmlData = [NSDictionary dictionaryWithXMLString:xmlString];
  
  if(xmlData != nil)
  {
    ExchangeRate *rateData = [[ExchangeRate alloc] initWithData: xmlData];
    handler(rateData);
  }
  else
  {
    handler(nil);
  }
}

@end
