//
//  HistogramViewController.m
//  Lab2
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "HistogramViewController.h"
#import <BEMSimpleLineGraphView.h>
#import <Masonry.h>

@interface HistogramViewController() <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic) NSMutableArray *array;
@property(nonatomic) NSMutableArray *R;
@property(nonatomic) NSMutableArray *G;
@property(nonatomic) NSMutableArray *B;

@property(nonatomic) CGFloat avR;
@property(nonatomic) CGFloat avG;
@property(nonatomic) CGFloat avB;
@property(nonatomic) NSInteger count;

@property(nonatomic) UIButton *pickButton;
@property(nonatomic) UILabel *label;
@property(nonatomic) UIImageView *sourceImage;
@property(nonatomic) BEMSimpleLineGraphView *rGraph;
@property(nonatomic) BEMSimpleLineGraphView *gGraph;
@property(nonatomic) BEMSimpleLineGraphView *bGraph;

@end

@implementation HistogramViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self countData];
    [self modifyData];
    [self createViews];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)countData
{
    self.array = [NSMutableArray array];
    self.R = [NSMutableArray array];
    self.G = [NSMutableArray array];
    self.B = [NSMutableArray array];
    for(int i = 0; i <= 255; i++) {
        [self.array addObject:@0];
        [self.R addObject:@0];
        [self.G addObject:@0];
        [self.B addObject:@0];
    }
    self.avR = self.avG = self.avB = self.count = 0;
    
    UIImage *image = self.image;
    CGContextRef ctx;
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    int byteIndex = 0;
    for (int ii = 0 ; ii < width * height ; ++ii)
    {
        int r = rawData[byteIndex];
        int g = rawData[byteIndex + 1];
        int b = rawData[byteIndex + 2];
        self.array[r] = @([self.array[r] integerValue] + 1);
        self.array[g] = @([self.array[g] integerValue] + 1);
        self.array[b] = @([self.array[b] integerValue] + 1);
        self.R[r] = @([self.R[r] integerValue] + 1);
        self.G[g] = @([self.G[g] integerValue] + 1);
        self.B[b] = @([self.B[b] integerValue] + 1);
        self.avR += r;
        self.avG += g;
        self.avB += b;
        self.count ++;
        byteIndex += 4;
    }
    
    ctx = CGBitmapContextCreate(rawData,
                                CGImageGetWidth( imageRef ),
                                CGImageGetHeight( imageRef ),
                                8,
                                bytesPerRow,
                                colorSpace,
                                kCGImageAlphaPremultipliedLast );
    CGColorSpaceRelease(colorSpace);
    
    imageRef = CGBitmapContextCreateImage (ctx);
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = myImage;
    self.sourceImage.image = myImage;
    [self countData];
    [self updateGraphs];
}

- (void)modifyData
{
//    CGFloat maxA = 0;
//    for(int i = 0; i < self.array.count - 1; i++) {
//        maxA = MAX([self.array[i] integerValue], maxA);
//    }
//    for(int i = 0; i < self.array.count - 1; i++) {
//        self.array[i] = @([self.array[i] integerValue] / maxA * 100);
//    }
}

- (void)pickButtonAction
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)createViews
{
    self.sourceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.sourceImage.image = self.image;
    [self.view addSubview:self.sourceImage];
    
    self.pickButton = [[UIButton alloc] initWithFrame:CGRectMake(650, 10, 70, 40)];
    [self.pickButton setTitle:@"Pick" forState:UIControlStateNormal];
    [self.pickButton addTarget:self action:@selector(pickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.pickButton];
    
    self.rGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(300, 0, 300, 200)];
    self.rGraph.dataSource = self;
    self.rGraph.delegate = self;
    [self.view addSubview:self.rGraph];
    self.rGraph.backgroundColor = [UIColor redColor];
    
    self.gGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 200, 300, 214)];
    self.gGraph.dataSource = self;
    self.gGraph.delegate = self;
    [self.view addSubview:self.gGraph];
    self.gGraph.backgroundColor = [UIColor greenColor];
    
    self.bGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(300, 200, 300, 214)];
    self.bGraph.dataSource = self;
    self.bGraph.delegate = self;
    [self.view addSubview:self.bGraph];
    self.bGraph.backgroundColor = [UIColor blueColor];
    
    self.avR/=self.count;
    self.avG/=self.count;
    self.avB/=self.count;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(600, 20, 100, 400)];
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.text = [NSString stringWithFormat:@"R: %.2f\nG: %.2f\nB: %.2f", self.avR, self.avG, self.avB];
    [self.view addSubview:self.label];
    
//    self.gGraph.enableYAxisLabel = YES;
//    self.gGraph.enableXAxisLabel = YES;
//    self.gGraph.autoScaleYAxis = YES;
//    self.gGraph.alwaysDisplayDots = YES;
//    self.gGraph.enableReferenceXAxisLines = YES;
//    self.gGraph.enableReferenceYAxisLines = YES;
//    self.gGraph.enableReferenceAxisFrame = YES;
}

- (void)updateGraphs {
    [self.rGraph reloadGraph];
    [self.gGraph reloadGraph];
    [self.bGraph reloadGraph];
    self.avR/=self.count;
    self.avG/=self.count;
    self.avB/=self.count;
    self.label.text = [NSString stringWithFormat:@"R: %.2f\nG: %.2f\nB: %.2f", self.avR, self.avG, self.avB];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    if ([self.rGraph isEqual:graph]) {
        return self.R.count;
    } else if ([self.gGraph isEqual:graph]) {
        return self.G.count;
    } else {
        return self.B.count;
    }
    return 0;
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    if ([self.rGraph isEqual:graph]) {
        return [self.R[index] integerValue];
    } else if ([self.gGraph isEqual:graph]) {
        return [self.G[index] integerValue];
    } else {
        return [self.B[index] integerValue];
    }
}
@end
