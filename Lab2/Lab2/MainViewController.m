//
//  MainViewController.m
//  Lab2
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry.h>
#import <FCColorPickerViewController.h>
#import "RGBTextFiledView.h"
#import "Categories.h"
#import <JTMaterialSpinner.h>
#import "HistogramViewController.h"
#import "TouchView.h"

@interface MainViewController() <FCColorPickerViewControllerDelegate>

@property (nonatomic, strong) UIImageView *sourceImageView;
@property (nonatomic, strong) UIImageView *resultImageView;

@property (nonatomic, strong) UIButton *firstColorButton;
@property (nonatomic, strong) UIButton *secondColorButton;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *histogramButton;
@property (nonatomic, strong) RGBTextFiledView *firstColorView;
@property (nonatomic, strong) RGBTextFiledView *secondColorView;

@property (nonatomic, weak) RGBTextFiledView *currentButtonView;
@property (nonatomic, weak) UIButton *currentButton;
@property (nonatomic, strong) JTMaterialSpinner *spinnerView;

@property (nonatomic, strong) UIView *sview;
@property (nonatomic, strong) TouchView *contentView;


@end

static const CGFloat offset = 15.f;
static NSString * const imageName = @"orange";

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self constructUI];
}

- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.firstColorButton = [UIButton new];
    self.firstColorButton.backgroundColor = [UIColor colorWithRed:100/255.f green:150.f/255.f blue:175/255.f alpha:1.f];
    self.firstColorButton.layer.cornerRadius = 5.f;
    [self.firstColorButton addTarget:self action:@selector(firstColorButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.firstColorButton];
    
    self.firstColorView = [RGBTextFiledView new];
    [self.firstColorView setColor:[UIColor colorWithRed:100/255.f green:150.f/255.f blue:175/255.f alpha:1.f]];
    self.firstColorView.colorButton = self.firstColorButton;
    [self.view addSubview:self.firstColorView];
    
    self.secondColorButton = [UIButton new];
    self.secondColorButton.backgroundColor = [UIColor colorWithRed:213/255.f green:85.f/255.f blue:213/255.f alpha:1.f];
    self.secondColorButton.layer.cornerRadius = 5.f;
    [self.secondColorButton addTarget:self action:@selector(secondColorButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.secondColorButton];
    
    self.secondColorView = [RGBTextFiledView new];
    [self.secondColorView setColor:[UIColor colorWithRed:213/255.f green:85.f/255.f blue:213/255.f alpha:1.f]];
    self.secondColorView.colorButton = self.secondColorButton;
    [self.view addSubview:self.secondColorView];
    
    self.slider = [UISlider new];
    self.slider.minimumValue = 0.05f;
    self.slider.maximumValue = 1.f;
    [self.view addSubview:self.slider];
    
    self.button = [UIButton new];
    [self.button setTitle:@"GO" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 5.f;
    self.button.backgroundColor = [UIColor lightGrayColor];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];

    self.histogramButton = [UIButton new];
    [self.histogramButton setTitle:@"Hist" forState:UIControlStateNormal];
    [self.histogramButton addTarget:self action:@selector(histogramButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.histogramButton.layer.cornerRadius = 5.f;
    self.histogramButton.backgroundColor = [UIColor lightGrayColor];
    [self.histogramButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.histogramButton];
    [self.histogramButton setHidden:YES];
    
    self.sourceImageView = [UIImageView new];
    self.sourceImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.sourceImageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:self.sourceImageView];
    
    self.resultImageView = [UIImageView new];
    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.resultImageView];
    
    self.spinnerView = [JTMaterialSpinner new];
    self.spinnerView.circleLayer.lineWidth = 3.0;
    self.spinnerView.circleLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.spinnerView];
}

- (void)constructUI
{
    [self.firstColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(offset);
        make.width.height.equalTo(@60);
    }];
    
    [self.firstColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.firstColorButton);
        make.width.equalTo(@50);
        make.left.equalTo(self.firstColorButton.mas_right).offset(offset);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstColorView.mas_right).offset(offset);
        make.centerY.equalTo(self.firstColorButton);
        make.height.equalTo(@30);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.mas_right).offset(offset);
        make.centerY.equalTo(self.firstColorButton);
        make.height.equalTo(@40);
        make.width.equalTo(@50);
    }];
    
    [self.histogramButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(offset);
        make.centerY.equalTo(self.firstColorButton);
        make.height.equalTo(@40);
        make.width.equalTo(@50);
    }];
    
    [self.secondColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.firstColorButton);
        make.width.equalTo(@50);
        make.left.equalTo(self.histogramButton.mas_right).offset(offset);
    }];
    
    [self.secondColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-offset);
        make.centerY.equalTo(self.firstColorButton);
        make.left.equalTo(self.secondColorView.mas_right).offset(offset);
        make.width.height.equalTo(self.firstColorButton);
    }];
    
    [self.sourceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(offset);
        make.top.equalTo(self.firstColorButton.mas_bottom).offset(offset);
        make.right.equalTo(self.view.mas_centerX).offset(-offset);
        make.bottom.offset(-offset);
    }];
    
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(offset);
        make.top.equalTo(self.firstColorButton.mas_bottom).offset(offset);
        make.right.bottom.offset(-offset);
    }];
    
    [self.spinnerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60.f);
        make.center.offset(0.f);
    }];
    
}

- (void)buttonAction
{
    [self.spinnerView beginRefreshing];
    __block UIImage *image;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [[UIImage imageNamed:imageName] changeFromColor:self.firstColorButton.backgroundColor toColor:self.secondColorButton.backgroundColor withRadius:self.slider.value];
        dispatch_async( dispatch_get_main_queue(), ^{
            _resultImageView.image = image;
            [_spinnerView endRefreshing];
        });
    });
}


- (void)firstColorButtonAction
{
    self.currentButton = self.firstColorButton;
    self.currentButtonView = self.firstColorView;
    [self pickColorActionForColor:self.firstColorButton.backgroundColor];
}

- (void)secondColorButtonAction
{
    self.currentButton = self.secondColorButton;
    self.currentButtonView = self.secondColorView;
    [self pickColorActionForColor:self.secondColorButton.backgroundColor];
}

- (void)pickColorActionForColor:(UIColor *)color
{
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
    colorPicker.color = color;
    colorPicker.delegate = self;
    colorPicker.backgroundColor = [UIColor whiteColor];
    colorPicker.tintColor = [UIColor blackColor];
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
}

- (void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color
{
    self.currentButton.backgroundColor = color;
    [self.currentButtonView setColor:color];
    [colorPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker
{
    [colorPicker dismissViewControllerAnimated:YES completion:nil];
}


- (void)histogramButtonAction
{
    HistogramViewController *controller = [HistogramViewController new];
    controller.imageName = imageName;
    [self presentViewController:controller animated:YES completion:nil];
}

@end


