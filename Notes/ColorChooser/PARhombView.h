//
//  PARhombView.h
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 10/29/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PARhombView : UIView

@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat size;

@property (assign, nonatomic) CGFloat saturationValue;
@property (assign, nonatomic) CGFloat brightnessValue;

- (instancetype)initWithSize:(CGFloat)size color:(UIColor *)color;
- (CGPoint)indicatorCenterForTouchLocation:(CGPoint)point;
- (CGPoint)indicatorCenterForSaturation:(CGFloat)saturation brightness:(CGFloat)brightness;

@end
