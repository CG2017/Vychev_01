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

@interface MainViewController() <FCColorPickerViewControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *sourceImageView;
@property (nonatomic, strong) UIImageView *resultImageView;

@property (nonatomic, strong) UIButton *firstColorButton;
@property (nonatomic, strong) UIButton *secondColorButton;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *pickButton;
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
static NSString * const imageName = @"japan";

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
    self.slider.maximumValue = 300.f;
    [self.view addSubview:self.slider];
    
    self.button = [UIButton new];
    [self.button setTitle:@"GO" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    self.button.layer.cornerRadius = 5.f;
    self.button.backgroundColor = [UIColor lightGrayColor];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    self.pickButton = [UIButton new];
    [self.pickButton setTitle:@"Pick" forState:UIControlStateNormal];
    [self.pickButton addTarget:self action:@selector(pickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.pickButton.layer.cornerRadius = 5.f;
    self.pickButton.backgroundColor = [UIColor lightGrayColor];
    [self.pickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.pickButton];

    self.histogramButton = [UIButton new];
    [self.histogramButton setTitle:@"Hist" forState:UIControlStateNormal];
    [self.histogramButton addTarget:self action:@selector(histogramButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.histogramButton.layer.cornerRadius = 5.f;
    self.histogramButton.backgroundColor = [UIColor lightGrayColor];
    [self.histogramButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.histogramButton];
    
    self.sourceImageView = [UIImageView new];
    self.sourceImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.sourceImageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:self.sourceImageView];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    self.sourceImageView.userInteractionEnabled = YES;
    [tapGestureRecognizer addTarget:self action:@selector(tapGestureHandler:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.sourceImageView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    
    
    
    self.resultImageView = [UIImageView new];
    self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.resultImageView];
    
    self.spinnerView = [JTMaterialSpinner new];
    self.spinnerView.circleLayer.lineWidth = 3.0;
    self.spinnerView.circleLayer.strokeColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.spinnerView];
}

- (void)tapGestureHandler:(UITapGestureRecognizer *)tgr {
    CGPoint coords = [tgr locationInView:self.sourceImageView];
    
    UIGraphicsBeginImageContext(self.sourceImageView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.sourceImageView.layer renderInContext:context];
    size_t bpr = CGBitmapContextGetBytesPerRow(context);
    unsigned char * data = CGBitmapContextGetData(context);
    if (data != NULL)
    {
        int offset = bpr*round(coords.y) + 4*round(coords.x);
        int blue = data[offset+0];
        int green = data[offset+1];
        int red = data[offset+2];
        int alpha =  data[offset+3];
        [self.firstColorButton setBackgroundColor:[UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:alpha / 255.f]];
        NSLog(@"%d %d %d %d", alpha, red, green, blue);
        
    }
    
    UIGraphicsEndImageContext();

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
    
    [self.pickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.button.mas_right).offset(offset);
        make.centerY.equalTo(self.firstColorButton);
        make.height.equalTo(@40);
        make.width.equalTo(@50);
    }];
    
    [self.histogramButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pickButton.mas_right).offset(offset);
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
        image = [self.sourceImageView.image changeFromColor:self.firstColorButton.backgroundColor toColor:self.secondColorButton.backgroundColor withRadius:self.slider.value];
        dispatch_async( dispatch_get_main_queue(), ^{
            _resultImageView.image = image;
            [_spinnerView endRefreshing];
        });
    });
}

- (void)pickButtonAction
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sourceImageView.image = myImage;
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
    controller.image = self.sourceImageView.image;
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end


