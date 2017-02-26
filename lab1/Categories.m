//
//  Categories.m
//  
//
//  Created by Andrew Vychev on 2/11/16.
//
//

#import "Categories.h"

@implementation UIColor(ColorTools)

+ (UIColor *)colorWithRGB:(int)rgbValue alpha:(float)alpha
{
    return [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorWithRGB:(int)rgbValue
{
    return [UIColor colorWithRGB:rgbValue alpha:1.0];
}

- (int)hexInt
{
    CGFloat red, green, blue;
    [self getRed:&red green:&green blue:&blue alpha:NULL];
    
    int a = (((int)lroundf(red * 255.f)) << 16) + (((int)lroundf(green * 255.f)) << 8) + (int)lroundf(blue * 255.f);
    return a;
}


@end
