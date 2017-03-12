//
//  SliderColorPickerView.h
//  Lab1
//
//  Created by Andrew Vychev on 2/11/16.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorConverterProtocol.h"

@protocol SliderColorPickerViewDelegate <NSObject>

- (void)colorChangedToColor:(NSInteger)colorInteger;

@end

@interface SliderColorPickerView : UIView

- (instancetype)initWithConverter:(id<ColorConverterProtocol>)converter;
- (void)colorChangedToRGBHexColor:(NSInteger)colorInteger;

@property (nonatomic, weak) id<SliderColorPickerViewDelegate> delegate;
@end
