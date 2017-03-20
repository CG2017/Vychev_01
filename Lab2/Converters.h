//
//  Converters.h
//  Lab1
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorConverterProtocol.h"

@interface LABConverter : NSObject <ColorConverterProtocol>

- (BOOL)compareDistanceBetweenColor:(UIColor *)oldColor tempColor:(UIColor *)tempColor radius:(CGFloat)radius;

@end
