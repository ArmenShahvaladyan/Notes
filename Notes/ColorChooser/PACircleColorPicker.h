//
//  PACircleColorPicker.h
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 10/24/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PACircleColorPicker;

@protocol PACircleColorPickerDelegate <NSObject>

- (void)colorPicker:(PACircleColorPicker *)colorPicker didSelectColor:(UIColor *)color;
- (void)colorPicker:(PACircleColorPicker *)colorPicker didSelectColorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;

@end


@interface PACircleColorPicker : UIControl

@property (strong, nonatomic) UIColor *color;

@property (assign, nonatomic) CGFloat hue;
@property (assign, nonatomic) CGFloat saturation;
@property (assign, nonatomic) CGFloat brightness;

@property (readonly, nonatomic) CGFloat radius;
@property (readonly, nonatomic) CGFloat donutWidth;

- (instancetype)initWithRadius:(CGFloat)radius
                    donutWidth:(CGFloat)donutWidth;

@property (weak, nonatomic) id <PACircleColorPickerDelegate> delegate;

@end
