//
//  RGBTextFiledView.h
//  Lab2
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGBTextFiledView : UIView

@property (nonatomic, weak) UIButton *colorButton;
- (void)setColor:(UIColor *)color;

@end
