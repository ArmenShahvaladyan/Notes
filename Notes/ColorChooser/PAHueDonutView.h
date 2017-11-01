//
//  PAHueDonutView.h
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 11/3/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAHueDonutView : UIView

@property (readonly, nonatomic) CGFloat radius;
@property (readonly, nonatomic) CGFloat donutWidth;
@property (readonly, nonatomic) CGFloat startAngle;
@property (readonly, nonatomic) CGFloat endAngle;

- (instancetype)initWithRadius:(CGFloat)radius
                    donutWidth:(CGFloat)donutWidth
                    startAngle:(CGFloat)startAngle
                      endAngle:(CGFloat)endAngle;

- (CGPoint)indicatorCenterForHueValue:(CGFloat)hue;
- (CGFloat)hueValueForTouchLocation:(CGPoint)point;

@end
