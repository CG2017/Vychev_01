//
//  TouchView.m
//  Lab2
//
//  Created by Andrew Vychev on 3/5/17.
//  Copyright © 2017 Andrew Vychev. All rights reserved.
//

#import "TouchView.h"
#import "Masonry.h"

@implementation TouchView


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint prev = [touch previousLocationInView:self];
    CGPoint temp = [touch locationInView:self];
    CGFloat dist = prev.y - temp.y;
    
    [self.dragView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(self.dragView.frame.origin.y - dist);
    }];
}

@end
