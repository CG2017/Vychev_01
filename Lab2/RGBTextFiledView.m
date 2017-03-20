//
//  RGBTextFiledView.m
//  Lab2
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "RGBTextFiledView.h"
#import <Masonry.h>

@interface RGBTextFiledView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *rTextField;
@property (nonatomic, strong) UITextField *gTextField;
@property (nonatomic, strong) UITextField *bTextField;

@end

@implementation RGBTextFiledView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self constructUI];
    }
    return self;
}

- (void)constructUI
{

    self.rTextField = [UITextField new];
    self.rTextField.layer.cornerRadius = 5.f;
    self.rTextField.text = @"";
    self.rTextField.delegate = self;
    self.rTextField.textAlignment = NSTextAlignmentCenter;
    self.rTextField.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.rTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:self.rTextField];
    
    self.gTextField = [UITextField new];
    self.gTextField.layer.cornerRadius = 5.f;
    self.gTextField.text = @"";
    self.gTextField.delegate = self;
    self.gTextField.textAlignment = NSTextAlignmentCenter;
    self.gTextField.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.gTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:self.gTextField];
    
    self.bTextField = [UITextField new];
    self.bTextField.layer.cornerRadius = 5.f;
    self.bTextField.text = @"";
    self.bTextField.delegate = self;
    self.bTextField.textAlignment = NSTextAlignmentCenter;
    self.bTextField.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.bTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:self.bTextField];

    self.rTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.rTextField.layer.borderWidth = 1.f;
    
    self.gTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.gTextField.layer.borderWidth = 1.f;
    
    self.bTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.bTextField.layer.borderWidth = 1.f;
    
    
    
    [self.rTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0.f);
        make.height.equalTo(self.mas_height).multipliedBy( 0.8f / 3);
    }];
    
    [self.gTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0.f);
        make.centerY.equalTo(self);
        make.height.equalTo(self.rTextField);
    }];
    
    [self.bTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0.f);
        make.height.equalTo(self.rTextField);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.colorButton.backgroundColor = [UIColor colorWithRed:[self.rTextField.text floatValue] / 255.f green:[self.gTextField.text floatValue] / 255.f blue:[self.bTextField.text floatValue] / 255.f alpha:1.f];
    return YES;
}

- (void)setColor:(UIColor *)color
{
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    self.rTextField.text = [NSString stringWithFormat:@"%.2f", red * 255.f];;
    self.gTextField.text = [NSString stringWithFormat:@"%.2f", green * 255.f];
    self.bTextField.text = [NSString stringWithFormat:@"%.2f", blue * 255.f];
}

@end
