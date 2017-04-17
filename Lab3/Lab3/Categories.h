//
//  Categories.h
//  
//
//  Created by Andrew Vychev on 3/5/17.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(ColorTools)

+ (UIColor *)colorWithRGB:(int)rgbValue alpha:(float)alpha;
+ (UIColor *)colorWithRGB:(int)rgbValue;
- (int)hexInt;

@end

@interface UIImage(ImageTools)

- (UIImage *)changeFromColor:(UIColor *)oldColor toColor:(UIColor *)newColor withRadius:(CGFloat)radius;

@end