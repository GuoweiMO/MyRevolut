//
//  ExchangeItemView.h
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyAmountLabelOutput <NSObject>

- (void)amountDidChangeToValue:(double)newValue;


@end

@interface CurrencyItemView : UIView

@property (weak, nonatomic) id<CurrencyAmountLabelOutput> textFieldOutput;

+ (CurrencyItemView *)viewFromNib;

- (void)updateViewWithCurrency:(NSString *)currency;

-(void)setAmountFieldToValue:(NSString *)value;
-(double)amountValue;
- (void)setAmountFieldAsFirstResponder;

@end
