//
//  Converters.m
//  Lab1
//
//  Created by Andrew Vychev on 2/11/16.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "Converters.h"
#import "Categories.h"

@implementation CMYConverter

- (void)convertSpecificColorWithFirstValue:(CGFloat)firstValue secondValue:(CGFloat)secondValue thirdValue:(CGFloat)thirdValue toRGBColor:(NSInteger *)colorInteger
{
    UIColor *color = [UIColor colorWithRed:1 - firstValue green:1 - secondValue blue:1 - thirdValue alpha:1.f];
    *colorInteger = [color hexInt];
}
- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue
{
    UIColor *color = [UIColor colorWithRGB:(int)colorInteger];
    CGFloat rValue, gValue, bValue;
    [color getRed:&rValue green:&gValue blue:&bValue alpha:NULL];
    
    *firstValue = 1 - rValue;
    *secondValue = 1 - gValue;
    *thirdValue = 1 - bValue;
}

- (CGFloat)firstMaxValue
{
    return 1.f;
}
- (CGFloat)secondMaxValue
{
    return 1.f;
}
- (CGFloat)thirdMaxValue
{
    return 1.f;
}

- (NSArray *)titlesForValues
{
    return @[@"C", @"M", @"Y"];
}

- (Boolean)hasWarning {
    return NO;
}

@end

@implementation RGBConverter

- (void)convertSpecificColorWithFirstValue:(CGFloat)firstValue secondValue:(CGFloat)secondValue thirdValue:(CGFloat)thirdValue toRGBColor:(NSInteger *)colorInteger
{
    UIColor *color = [UIColor colorWithRed:firstValue / 255.f green:secondValue / 255.f blue:thirdValue / 255.f alpha:1.f];
    *colorInteger = [color hexInt];
}
- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue
{
    UIColor *color = [UIColor colorWithRGB:(int)colorInteger];
    CGFloat rValue, gValue, bValue;
    [color getRed:&rValue green:&gValue blue:&bValue alpha:NULL];
    
    *firstValue = lroundf(rValue * 255);
    *secondValue = lroundf(gValue * 255);
    *thirdValue = lroundf(bValue * 255);
}

- (CGFloat)firstMaxValue
{
    return 255.f;
}

- (CGFloat)secondMaxValue
{
    return 255.f;
}
- (CGFloat)thirdMaxValue
{
    return 255.f;
}

- (NSArray *)titlesForValues
{
    return @[@"R", @"G", @"B"];
}

- (Boolean)hasWarning {
    return NO;
}

@end

@implementation LUVConverter

- (void)convertSpecificColorWithFirstValue:(CGFloat)firstValue secondValue:(CGFloat)secondValue thirdValue:(CGFloat)thirdValue toRGBColor:(NSInteger *)colorInteger
{
    self.mHasSpecificColorWarning = NO;
    CGFloat x, y, z;
    if(fabs(thirdValue) < 1e-4) {
        x = 0;
        y = 0;
        z = 0;
        self.mHasSpecificColorWarning = YES;
    } else {
        y = firstValue;
        CGFloat eq = 9.f * y / thirdValue;
        x = secondValue * eq / 4.f;
        z = (eq - x - 15.f * y) / 3.f;
    }
    
    x /= 100.f;
    y /= 100.f;
    z /= 100.f;
    
    CGFloat rValue = 3.24071 * x - 1.53726 * y - 0.498571 * z;
    CGFloat gValue = -0.969258 * x + 1.87599 * y + 0.0415557 * z;
    CGFloat bValue = 0.0556352 * x - 0.203996 * y + 1.05707 * z;
    
    if(rValue > 0.0031308) {
        rValue = 1.055 * (pow(rValue, 1 / 2.4)) - 0.055;
    }
    else {
        rValue *= 12.92;
    }
    
    if(gValue > 0.0031308) {
        gValue = 1.055 * (pow(gValue, 1 / 2.4)) - 0.055;
    }
    else {
        gValue *= 12.92;
    }
    
    if(bValue > 0.0031308) {
        bValue = 1.055 * (pow(bValue, 1 / 2.4)) - 0.055;
    }
    else {
        bValue *= 12.92;
    }
    
    if(rValue < 0.f) {
        self.mHasSpecificColorWarning = YES;
        rValue = 0.f;
    }
    if(rValue > 1.f) {
        self.mHasSpecificColorWarning = YES;
        rValue = 1.f;
    }
    if(gValue < 0.f) {
        self.mHasSpecificColorWarning = YES;
        gValue = 0.f;
    }
    if(gValue > 1.f) {
        self.mHasSpecificColorWarning = YES;
        gValue = 1.f;
    }
    if(bValue < 0.f) {
        self.mHasSpecificColorWarning = YES;
        bValue = 0.f;
    }
    if(bValue > 1.f) {
        self.mHasSpecificColorWarning = YES;
        bValue = 1.f;
    }
    
    UIColor *color = [UIColor colorWithRed:rValue green:gValue blue:bValue alpha:1.f];
    *colorInteger = [color hexInt];
}
- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue
{
    self.mHasRgbColorWarning = NO;
    UIColor *color = [UIColor colorWithRGB:(int)colorInteger];
    CGFloat rValue, gValue, bValue;
    [color getRed:&rValue green:&gValue blue:&bValue alpha:NULL];
    
    if(rValue <= 0.4045) {
        rValue /= 12.92;
    } else {
        rValue = pow((rValue + 0.055) / 1.055, 2.4);
    }
    
    if(gValue <= 0.4045) {
        gValue /= 12.92;
    } else {
        gValue = pow((gValue + 0.055) / 1.055, 2.4);
    }
    
    if(bValue <= 0.4045) {
        bValue /= 12.92;
    } else {
        bValue = pow((bValue + 0.055) / 1.055, 2.4);
    }
    
    rValue *= 100;
    gValue *= 100;
    bValue *= 100;
    

    CGFloat x = 0.4124 * rValue + 0.3576 * gValue + 0.1805 * bValue;
    CGFloat y = 0.2126 * rValue + 0.7152 * gValue + 0.0722 * bValue;
    CGFloat z = 0.0193 * rValue + 0.1192 * gValue + 0.9505 * bValue;

    *firstValue = y;
    if(fabs(x) < 1e-4 && fabs(z)<1e-4) {
        self.mHasRgbColorWarning = YES;
        *secondValue = 0;
        *thirdValue = 0;
    } else {
        *secondValue = 4 * x / (x + 15 * y + 3 * z);
        *thirdValue = 9 * y / (x + 15 * y + 3 * z);
    }
}

- (CGFloat)firstMaxValue
{
    return 100.f;
}

- (CGFloat)secondMaxValue
{
    return 0.7f;
}

- (CGFloat)thirdMaxValue
{
    return 0.6f;
}

- (NSArray *)titlesForValues
{
    return @[@"L", @"u'", @"v'"];
}

- (Boolean)hasWarning {
    Boolean result = self.mHasSpecificColorWarning | self.mHasRgbColorWarning;
    self.mHasSpecificColorWarning = NO;
    self.mHasRgbColorWarning = NO;
    return result;
}

@end


@implementation HSVConverter

- (void)convertSpecificColorWithFirstValue:(CGFloat)h secondValue:(CGFloat)s thirdValue:(CGFloat)v toRGBColor:(NSInteger *)colorInteger
{
    self.mHasSpecificColorWarning = NO;
    CGFloat      hh, p, q, t, ff;
    long        i;
    
    CGFloat r, g, b;
    
    if(s <= 0.0) {
        r = v;
        g = v;
        b = v;
        self.mHasSpecificColorWarning = YES;
        UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.f];
        *colorInteger = [color hexInt];
        return;
    }
    hh = h;
    if(hh >= 360.0) hh = 0.0;
    hh /= 60.0;
    i = (long)hh;
    ff = hh - i;
    p = v * (1.0 - s);
    q = v * (1.0 - (s * ff));
    t = v * (1.0 - (s * (1.0 - ff)));
    
    switch(i) {
        case 0:
            r = v;
            g = t;
            b = p;
            break;
        case 1:
            r = q;
            g = v;
            b = p;
            break;
        case 2:
            r = p;
            g = v;
            b = t;
            break;
            
        case 3:
            r = p;
            g = q;
            b = v;
            break;
        case 4:
            r = t;
            g = p;
            b = v;
            break;
        case 5:
        default:
            r = v;
            g = p;
            b = q;
            break;
    }
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    *colorInteger = [color hexInt];
}

- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue
{
    self.mHasRgbColorWarning = NO;
    UIColor *color = [UIColor colorWithRGB:(int)colorInteger];
    CGFloat R, G, B;
    [color getRed:&R green:&G blue:&B alpha:NULL];
    
    // H - в градусах
    
    CGFloat maxVal = fmax(R, fmax(G, B));
    CGFloat minVal = fmin(R, fmin(G, B));
    
    CGFloat H, S, V;
    
    V = maxVal;
    
    if(maxVal == 0 )
        S = 0;
    else
        S = ( maxVal - minVal )/maxVal;
    if( S == 0 ) {
        H = 0;
        self.mHasRgbColorWarning = YES;
    }
    else
    {
        if( R == maxVal )
            H = (G-B)/(maxVal - minVal );
        else if( G == maxVal )
            H = 2 + (B-R)/(maxVal - minVal );
        else if( B == maxVal )
            H = 4 + (R-G)/(maxVal - minVal );
        H = H * 60;
        if( H < 0 )
            H = H + 360;
    }

    
    *firstValue = H;
    *secondValue = S;
    *thirdValue = V;
}

- (CGFloat)firstMaxValue
{
    return 360.f;
}
- (CGFloat)secondMaxValue
{
    return 1.f;
}
- (CGFloat)thirdMaxValue
{
    return 1.f;
}

- (NSArray *)titlesForValues
{
    return @[@"H", @"S", @"V"];
}

- (Boolean)hasWarning {
    Boolean result = self.mHasSpecificColorWarning | self.mHasRgbColorWarning;
    self.mHasRgbColorWarning = NO;
    self.mHasSpecificColorWarning = NO;
    return result;
}

@end

