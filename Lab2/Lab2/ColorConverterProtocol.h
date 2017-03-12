//
//  ColorConverterProtocol.h
//  Lab1
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#ifndef ColorConverterProtocol_h
#define ColorConverterProtocol_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ColorConverterProtocol <NSObject>

- (void)convertSpecificColorWithFirstValue:(CGFloat)firstValue secondValue:(CGFloat)secondValue thirdValue:(CGFloat)thirdValue toRGBColor:(NSInteger *)colorInteger;
- (void)convertRGBColor:(NSInteger)colorInteger toSpecificColorWithFirstValue:(CGFloat *)firstValue secondValue:(CGFloat *)secondValue thirdValue:(CGFloat *)thirdValue;

- (NSArray *)titlesForValues;
- (CGFloat)firstMaxValue;
- (CGFloat)secondMaxValue;
- (CGFloat)thirdMaxValue;
@end

#endif /* ColorConverterProtocol_h */
