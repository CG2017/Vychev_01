//
//  Converters.h
//  Lab1
//
//  Created by Andrew Vychev on 2/11/16.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorConverterProtocol.h"

@interface CMYConverter : NSObject <ColorConverterProtocol>

@end

@interface RGBConverter : NSObject <ColorConverterProtocol>
    
@end

@interface LUVConverter : NSObject <ColorConverterProtocol>
    @property Boolean mHasSpecificColorWarning;
    @property Boolean mHasRgbColorWarning;
@end

@interface HSVConverter : NSObject <ColorConverterProtocol>
    @property Boolean mHasSpecificColorWarning;
    @property Boolean mHasRgbColorWarning;
@end
