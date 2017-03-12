//
//  SliderColorPickerView.m
//  Lab1
//
//  Created by Andrew Vychev on 2/11/16.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "SliderColorPickerView.h"
#import <Masonry.h>
#import "ColorConverterProtocol.h"

@interface SliderColorPickerView() <UITextFieldDelegate>

@property (nonatomic, strong) UISlider *firstSlider;
@property (nonatomic, strong) UISlider *secondSlider;
@property (nonatomic, strong) UISlider *thirdSlider;

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;

@property (nonatomic, strong) UITextField *firstTextField;
@property (nonatomic, strong) UITextField *secondTextField;
@property (nonatomic, strong) UITextField *thirdTextField;

@property (nonatomic, strong) id<ColorConverterProtocol> converter;
@property (nonatomic, assign, getter=isChanging) BOOL changing;

@end

static const CGFloat offset = 5.f;

@implementation SliderColorPickerView

- (instancetype)initWithConverter:(id<ColorConverterProtocol>)converter
{
    self = [super init];
    if (self) {
        self.converter = converter;
        [self createViews];
        [self constructUI];
    }
    return self;
}

- (void)createViews
{
    self.firstSlider = [UISlider new];
    self.firstSlider.minimumValue = 0.f;
    self.firstSlider.maximumValue = [self.converter firstMaxValue];
    [self.firstSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.secondSlider = [UISlider new];
    self.secondSlider.minimumValue = 0.f;
    self.secondSlider.maximumValue = [self.converter secondMaxValue];
    [self.secondSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.thirdSlider = [UISlider new];
    self.thirdSlider.minimumValue = 0.f;
    self.thirdSlider.maximumValue = [self.converter thirdMaxValue];
    [self.thirdSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.firstTextField = [UITextField new];
    self.firstTextField.layer.cornerRadius = 3.f;
    self.firstTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.firstTextField.layer.borderWidth = 1.f;
    self.firstTextField.delegate = self;
    self.firstTextField.backgroundColor = [UIColor whiteColor];
    self.firstTextField.textAlignment = NSTextAlignmentCenter;
    self.firstTextField.text = @"0";
    
    self.secondTextField = [UITextField new];
    self.secondTextField.layer.cornerRadius = 3.f;
    self.secondTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.secondTextField.layer.borderWidth = 1.f;
    self.secondTextField.backgroundColor = [UIColor whiteColor];
    self.secondTextField.delegate = self;
    self.secondTextField.textAlignment = NSTextAlignmentCenter;
    self.secondTextField.text = @"0";
    
    self.thirdTextField = [UITextField new];
    self.thirdTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.thirdTextField.layer.cornerRadius = 3.f;
    self.thirdTextField.layer.borderWidth = 1.f;
    self.thirdTextField.backgroundColor = [UIColor whiteColor];
    self.thirdTextField.delegate = self;
    self.thirdTextField.textAlignment = NSTextAlignmentCenter;
    self.thirdTextField.text = @"0";
    
    self.firstLabel = [UILabel new];
    self.firstLabel.backgroundColor = [UIColor whiteColor];
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    self.firstLabel.textColor = [UIColor blackColor];
    self.firstLabel.text = [self.converter titlesForValues][0];
    
    self.secondLabel = [UILabel new];
    self.secondLabel.backgroundColor = [UIColor whiteColor];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    self.secondLabel.textColor = [UIColor blackColor];
    self.secondLabel.text = [self.converter titlesForValues][1];
    
    self.thirdLabel = [UILabel new];
    self.thirdLabel.backgroundColor = [UIColor whiteColor];
    self.thirdLabel.textAlignment = NSTextAlignmentCenter;
    self.thirdLabel.textColor = [UIColor blackColor];
    self.thirdLabel.text = [self.converter titlesForValues][2];
    
    [self addSubview:self.firstSlider];
    [self addSubview:self.secondSlider];
    [self addSubview:self.thirdSlider];

    [self addSubview:self.firstTextField];
    [self addSubview:self.secondTextField];
    [self addSubview:self.thirdTextField];
    
    [self addSubview:self.firstLabel];
    [self addSubview:self.secondLabel];
    [self addSubview:self.thirdLabel];
    
    [self.firstSlider setTintColor:[UIColor cyanColor]];
    [self.secondSlider setTintColor:[UIColor cyanColor]];
    [self.thirdSlider setTintColor:[UIColor cyanColor]];
}

- (void)constructUI
{
    [self.firstSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.right.equalTo(self.firstLabel.mas_left).with.offset(-offset);
    }];
    
    [self.secondSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.secondLabel.mas_left).with.offset(-offset);
    }];
    
    [self.thirdSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.thirdLabel.mas_left).with.offset(-offset);
        make.bottom.equalTo(self);
    }];
    
    [self.firstTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-offset);
        make.centerY.equalTo(self.firstSlider.mas_centerY);
        make.width.equalTo(@80);
    }];
    
    [self.secondTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondSlider.mas_centerY);
        make.right.equalTo(self).with.offset(-offset);
        make.width.equalTo(self.firstTextField);
    }];

    [self.thirdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thirdSlider.mas_centerY);
        make.right.equalTo(self).with.offset(-offset);
        make.width.equalTo(self.firstTextField);
    }];
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.firstTextField.mas_left).with.offset(-offset);
        make.centerY.equalTo(self.firstSlider.mas_centerY);
        make.width.equalTo(@20);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.secondTextField.mas_left).with.offset(-offset);
        make.centerY.equalTo(self.secondSlider.mas_centerY);
        make.width.equalTo(self.firstLabel);
    }];
    
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thirdTextField.mas_left).with.offset(-offset);
        make.centerY.equalTo(self.thirdSlider.mas_centerY);
        make.width.equalTo(self.firstLabel);
    }];
}

- (void)colorChangedToRGBHexColor:(NSInteger)colorInteger
{
    [self.firstSlider setTintColor:[UIColor cyanColor]];
    [self.secondSlider setTintColor:[UIColor cyanColor]];
    [self.thirdSlider setTintColor:[UIColor cyanColor]];
    self.changing = YES;
    CGFloat firstValue, secondValue, thirdValue;
    
    [self.converter convertRGBColor:colorInteger toSpecificColorWithFirstValue:&firstValue secondValue:&secondValue thirdValue:&thirdValue];
    if ([self.converter hasWarning]) {
        [self.firstSlider setTintColor:[UIColor redColor]];
        [self.secondSlider setTintColor:[UIColor redColor]];
        [self.thirdSlider setTintColor:[UIColor redColor]];
    }
    
    self.firstSlider.value = firstValue;
    self.secondSlider.value = secondValue;
    self.thirdSlider.value = thirdValue;
    
    self.firstTextField.text = [NSString stringWithFormat:@"%.2f", firstValue];
    self.secondTextField.text = [NSString stringWithFormat:@"%.2f", secondValue];
    self.thirdTextField.text = [NSString stringWithFormat:@"%.2f", thirdValue];
    
    self.changing = NO;
}

- (void)sliderValueChanged:(id)sender
{
    
    self.changing = YES;
    [self.firstSlider setTintColor:[UIColor cyanColor]];
    [self.secondSlider setTintColor:[UIColor cyanColor]];
    [self.thirdSlider setTintColor:[UIColor cyanColor]];
//    if (self.isChanging) {
//        return;
//    }

    NSInteger colorRGBInteger;
    [self.converter convertSpecificColorWithFirstValue:self.firstSlider.value secondValue:self.secondSlider.value thirdValue:self.thirdSlider.value toRGBColor:&colorRGBInteger];
    
    if ([self.converter hasWarning]) {
        [self.firstSlider setTintColor:[UIColor redColor]];
        [self.secondSlider setTintColor:[UIColor redColor]];
        [self.thirdSlider setTintColor:[UIColor redColor]];
    } 
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorChangedToColor:)]) {
        [self.delegate colorChangedToColor:colorRGBInteger];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.isChanging) {
        return YES;
    }
    NSInteger colorRGBInteger;
    [self.converter convertSpecificColorWithFirstValue:[self.firstTextField.text floatValue] secondValue:[self.secondTextField.text floatValue] thirdValue:[self.thirdTextField.text floatValue] toRGBColor:&colorRGBInteger];
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorChangedToColor:)]) {
        [self.delegate colorChangedToColor:colorRGBInteger];
    }
    return YES;
}



@end
