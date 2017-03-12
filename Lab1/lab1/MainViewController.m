//
//  MainViewController.m
//  Lab1
//
//  Created by Andrew Vychev on 2/11/16.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry.h>
#import "SliderColorPickerView.h"
#import "Converters.h"
#import "Categories.h"
#import <FCColorPickerViewController.h>

@interface MainViewController() <SliderColorPickerViewDelegate, FCColorPickerViewControllerDelegate>

@property (nonatomic, strong) SliderColorPickerView *rgbPickerView;
@property (nonatomic, strong) SliderColorPickerView *cmyPickerView;
@property (nonatomic, strong) SliderColorPickerView *hsvPickerView;
@property (nonatomic, strong) SliderColorPickerView *luvPickerView;

@property (nonatomic, strong) UIButton *pickColor;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createViews];
    [self constructUI];
}

- (void)createViews
{
    RGBConverter *rgbConverter = [RGBConverter new];
    self.rgbPickerView = [[SliderColorPickerView alloc] initWithConverter:rgbConverter];
    self.rgbPickerView.delegate = self;
    [self.view addSubview:self.rgbPickerView];
    
    CMYConverter *cmyConverter = [CMYConverter new];
    self.cmyPickerView = [[SliderColorPickerView alloc] initWithConverter:cmyConverter];
    self.cmyPickerView.delegate = self;
    [self.view addSubview:self.cmyPickerView];
    
    HSVConverter *hsvConverter = [HSVConverter new];
    self.hsvPickerView = [[SliderColorPickerView alloc] initWithConverter:hsvConverter];
    self.hsvPickerView.delegate = self;
    [self.view addSubview:self.hsvPickerView];
    
    LUVConverter *luvConverter = [LUVConverter new];
    self.luvPickerView = [[SliderColorPickerView alloc] initWithConverter:luvConverter];
    self.luvPickerView.delegate = self;
    [self.view addSubview:self.luvPickerView];
    
    self.pickColor = [UIButton new];
    self.pickColor.backgroundColor = [UIColor grayColor];
    self.pickColor.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pickColor.layer.cornerRadius = 8.f;
    [self.pickColor setTitle:@"Color picker" forState:UIControlStateNormal];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickColorAction)];
    [self.pickColor addGestureRecognizer:tapRecognizer];
    [self.view addSubview:self.pickColor];
}

- (void)constructUI
{
    
    [self.rgbPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(30.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    
    [self.cmyPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rgbPickerView.mas_bottom).with.offset(30.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    
    [self.hsvPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cmyPickerView.mas_bottom).with.offset(30.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    
    [self.luvPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hsvPickerView.mas_bottom).with.offset(30.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    
    [self.pickColor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).with.offset(-10.f);
        make.left.equalTo(self.view).with.offset(10.f);
        make.top.equalTo(self.luvPickerView.mas_bottom).with.offset(10.f);
    }];
}

- (void)colorChangedToColor:(NSInteger)colorInteger {
    [self.rgbPickerView colorChangedToRGBHexColor:colorInteger];
    [self.cmyPickerView colorChangedToRGBHexColor:colorInteger];
    [self.hsvPickerView colorChangedToRGBHexColor:colorInteger];
    [self.luvPickerView colorChangedToRGBHexColor:colorInteger];
    self.view.backgroundColor = [UIColor colorWithRGB:(int)colorInteger];
}

- (void)pickColorAction
{
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = self.view.backgroundColor;
    colorPicker.delegate = self;
    colorPicker.backgroundColor = [UIColor whiteColor];
    colorPicker.tintColor = [UIColor blackColor];
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color
{
    [self colorChangedToColor:[color hexInt]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
