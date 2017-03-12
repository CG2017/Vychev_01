//
//  Converters.m
//  Lab1
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "Converters.h"
#import "Categories.h"

@implementation LABConverter

- (void)convertSpecificColorWithFirstValue:(CGFloat)firstValue secondValue:(CGFloat)secondValue thirdValue:(CGFloat)thirdValue toRGBColor:(NSInteger *)colorInteger
{
    CGFloat x, y, z;
    y = ( firstValue + 16 ) / 116.f;
    x = secondValue / 500.f + y;
    z = y - thirdValue / 200.f;
    
    if ( pow(x, 3) > 0.008856 ) {
        x = pow(x, 3);
    } else {
        x = (x - 16.f / 116 ) / 7.787;
    }
    if ( pow(y, 3) > 0.008856 ) {
        y = pow (y, 3);
    } else {
        y = (y - 16.f / 116 ) / 7.787;
    }
    if ( pow(z, 3) > 0.008856 ) {
        z = pow (z, 3);
    } else {
        z = (z - 16.f / 116 ) / 7.787;
    }
    
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
        rValue = 0.f;
    }
    if(rValue > 1.f) {
        rValue = 1.f;
    }
    if(gValue < 0.f) {
        gValue = 0.f;
    }
    if(gValue > 1.f) {
        gValue = 1.f;
    }
    if(bValue < 0.f) {
        bValue = 0.f;
    }
    if(bValue > 1.f) {
        bValue = 1.f;
    }
    
    UIColor *color = [UIColor colorWithRed:rValue green:gValue blue:bValue alpha:1.f];
    *colorInteger = [color hexInt];
}

- (BOOL)compareDistanceBetweenColor:(UIColor *)oldColor tempColor:(UIColor *)tempColor radius:(CGFloat)radius
{
    CGFloat oldL, oldU, oldV, tempL, tempU, tempV;
//    [oldColor getRed:&oldL green:&oldU blue:&oldV alpha:NULL];
//    [tempColor getRed:&tempL green:&tempU blue:&tempV alpha:NULL];
    [self convertRGBColor:[oldColor hexInt] toSpecificColorWithFirstValue:&oldL secondValue:&oldU thirdValue:&oldV];
    [self convertRGBColor:[tempColor hexInt] toSpecificColorWithFirstValue:&tempL secondValue:&tempU thirdValue:&tempV];
    oldL = oldL / 100;
    tempL = tempL / 100;
    oldU = oldU / 256;
    tempU = tempU / 256;
    oldV = oldV / 256;
    tempV = tempV / 256;
    CGFloat dist = sqrtf((oldL - tempL) * (oldL - tempL) + (oldU - tempU) * (oldU - tempU) + (oldV - tempV) * (oldV - tempV));
    return dist < radius;
}

- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue
{
    UIColor *color = [UIColor colorWithRGB:(int)colorInteger];
    CGFloat rValue, gValue, bValue;
    [color getRed:&rValue green:&gValue blue:&bValue alpha:NULL];
    
    if(rValue <= 0.04045) {
        rValue /= 12.92;
    } else {
        rValue = pow((rValue + 0.055) / 1.055, 2.4);
    }
    
    if(gValue <= 0.04045) {
        gValue /= 12.92;
    } else {
        gValue = pow((gValue + 0.055) / 1.055, 2.4);
    }
    
    if(bValue <= 0.04045) {
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
    
    CGFloat refX =  95.047;
    CGFloat refY = 100.000;
    CGFloat refZ = 108.883;
    
    x /= refX;          //ref_X =  95.047   Observer= 2°, Illuminant= D65
    y /= refY;          //ref_Y = 100.000
    z /= refZ;          //ref_Z = 108.883
    
    if ( x > 0.008856 ) {
        x = pow(x, 1.f/ 3);
    } else {
        x = ( 7.787 * x ) + ( 16.f / 116 );
    }
    if ( y > 0.008856 ) {
        y = pow (y , 1.f / 3);
    } else {
        y = ( 7.787 * y ) + ( 16.f / 116.f );
    }
    if ( z > 0.008856 ) {
        z = pow (z , 1.f / 3);
    } else {
        z = ( 7.787 * z ) + ( 16.f / 116.f );
    }
    
                            
    *firstValue = ( 116 * y ) - 16;
    *secondValue = 500 * ( x - y );
    *thirdValue = 200 * ( y - z );
}

- (CGFloat)firstMaxValue
{
    return 0;
}
- (CGFloat)secondMaxValue
{
    return 0;
}
- (CGFloat)thirdMaxValue
{
    return 0;
}
- (NSArray *)titlesForValues
{
    return @[@"L", @"a", @"b"];
}

@end




