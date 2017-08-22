//
//  ExchangeItemView.m
//  MyRevolut
//
//  Created by Guowei Mo on 20/08/2017.
//  Copyright © 2017 Guowei Mo. All rights reserved.
//

#import "CurrencyItemView.h"

@interface CurrencyItemView ()

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UITextField *amountField;

@end

@implementation CurrencyItemView

+ (CurrencyItemView *)viewFromNib
{
  return (CurrencyItemView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CurrencyItemView class]) owner:self options:nil] firstObject];
}

- (void)updateViewWithCurrency:(NSString *)currency
{
  _currencyLabel.text = currency;
}

-(void)setAmountFieldToValue:(NSString *)value;
{
  _amountField.text = value;
}

- (void)setAmountFieldAsFirstResponder
{
  [_amountField becomeFirstResponder];
}

-(double)amountValue
{
  return ABS([_amountField.text doubleValue]);
}

- (IBAction)amountFieldDidChange:(UITextField *)sender {
  double newValue = ABS([sender.text doubleValue]);
  if([_textFieldOutput conformsToProtocol:@protocol(CurrencyAmountLabelOutput)]){
    [_textFieldOutput amountDidChangeToValue:newValue];
  }
}

@end
