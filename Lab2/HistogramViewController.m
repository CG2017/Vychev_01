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

@interface HistogramViewController() <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property(nonatomic) NSMutableArray *array;
@property(nonatomic) NSMutableArray *R;
@property(nonatomic) NSMutableArray *G;
@property(nonatomic) NSMutableArray *B;

@property(nonatomic) CGFloat avR;
@property(nonatomic) CGFloat avG;
@property(nonatomic) CGFloat avB;
@property(nonatomic) NSInteger count;

@property(nonatomic) BEMSimpleLineGraphView *averageGraph;
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

- (void)createViews
{
    self.averageGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.averageGraph.dataSource = self;
    self.averageGraph.delegate = self;
    [self.view addSubview:self.averageGraph];
    self.averageGraph.backgroundColor = [UIColor yellowColor];
//    [self.averageGraph setHidden:YES];
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(600, 20, 100, 400)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"R: %.2f\nG: %.2f\nB: %.2f", self.avR, self.avG, self.avB];
    [self.view addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(650, 10, 70, 40)];
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    if ([self.averageGraph isEqual:graph]) {
        return self.array.count;
    } else if ([self.rGraph isEqual:graph]) {
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
    if ([self.averageGraph isEqual:graph]) {
        return [self.array[index] integerValue];
    } else if ([self.rGraph isEqual:graph]) {
        return [self.R[index] integerValue];
    } else if ([self.gGraph isEqual:graph]) {
        return [self.G[index] integerValue];
    } else {
        return [self.B[index] integerValue];
    }
}
@end
