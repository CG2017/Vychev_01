//
//  Categories.h
//  
//
//  Created by Andrew Vychev on 2/11/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(ColorTools)

+ (UIColor *)colorWithRGB:(int)rgbValue alpha:(float)alpha;
+ (UIColor *)colorWithRGB:(int)rgbValue;
- (int)hexInt;

@end
