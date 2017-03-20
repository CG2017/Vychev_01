//
//  Categories.m
//  
//
//  Created by Andrew Vychev on 3/5/17.
//
//

#import "Categories.h"
#import "Converters.h"


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

@implementation UIImage(ImageTools)

- (UIImage *)changeFromColor:(UIColor *)oldColor toColor:(UIColor *)newColor withRadius:(CGFloat)radius
{
    LABConverter *converter = [LABConverter new];
    
    CGFloat oldColR, oldColG, oldColB;
//    [oldColor getRed:&oldColR green:&oldColG blue:&oldColB alpha:NULL];
    [converter convertRGBColor:[oldColor hexInt] toSpecificColorWithFirstValue:&oldColR secondValue:&oldColG thirdValue:&oldColB];
    CGFloat newColR, newColG, newColB;
    [converter convertRGBColor:[newColor hexInt] toSpecificColorWithFirstValue:&newColR secondValue:&newColG thirdValue:&newColB];
    CGFloat oldR, oldG, oldB, newR, newG, newB;
    oldR = oldColR;
    oldG = oldColG;
    oldB = oldColB;
    newR = newColR;
    newG = newColG;
    newB = newColB;
    
    CGContextRef ctx;
    CGImageRef imageRef = [self CGImage];
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
        if ([converter compareDistanceBetweenColor:oldColor tempColor:[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f] radius:radius]) {
            CGFloat r,g,b;
            [converter convertRGBColor:[[UIColor colorWithRed:rawData[byteIndex] / 255.f green:rawData[byteIndex + 1] / 255.f blue:rawData[byteIndex + 2] / 255.f alpha:1.f] hexInt] toSpecificColorWithFirstValue:&r secondValue:&g thirdValue:&b];
//            CGFloat nR = MAX(MIN(newR + (r - oldR), 100), 0);
//            CGFloat nG = MAX(MIN(newG + (g - oldG), 128), -128);
//            CGFloat nB = MAX(MIN(newB + (b - oldB), 128), -128);
            CGFloat nR = newR + (r - oldR);
            CGFloat nG = newG + (g - oldG);
            CGFloat nB = newB + (b - oldB);
            CGFloat red, green, blue;
            NSInteger nColor;
            [converter convertSpecificColorWithFirstValue:nR secondValue:nG thirdValue:nB toRGBColor:&nColor];
            [[UIColor colorWithRGB:(int)nColor] getRed:&red green:&green blue:&blue alpha:NULL];
            rawData[byteIndex] = (int)(red * 255);
            rawData[byteIndex+1] = (int)(green * 255);
            rawData[byteIndex+2] = (int)(blue * 255.f);
        }
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
    UIImage* rawImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    free(rawData);
    
    return rawImage;
}

@end
