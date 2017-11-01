//
//  PASliderColorView.m
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/11/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PASliderColorView.h"

@interface PASliderColorView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end
@implementation PASliderColorView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0].CGColor;
        self.layer.cornerRadius = self.bounds.size.height / 2;
        self.layer.masksToBounds = YES;
        
        
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    }
    return _gradientLayer;
}

- (void)setType:(PAColorSliderType)type
{
    _type = type;
}

- (void)setFirstOtherComponentValue:(CGFloat)firstOtherComponentValue
{
    _firstOtherComponentValue = firstOtherComponentValue;
}

- (void)setSecondOtherComponentValue:(CGFloat)secondOtherComponentValue
{
    _secondOtherComponentValue = secondOtherComponentValue;
}

- (void)update
{
    NSArray *colors;
    switch (self.type) {
        case PAColorSliderTypeHue:
            colors = [self colorsForHueGradient];
            break;
        case PAColorSliderTypeSaturation:
            colors = [self colorsForSaturationGradient];
            break;
        case PAColorSliderTypeBrightness:
            colors = [self colorsForBrightnessGradient];
            break;
        case PAColorSliderTypeRed:
            colors = [self colorsForRedGradient];
            break;
        case PAColorSliderTypeGreen:
            colors = [self colorsForGreenGradient];
            break;
        case PAColorSliderTypeBlue:
            colors = [self colorsForBlueGradient];
            break;
    }
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.colors = colors;
    [CATransaction commit];
}

- (NSArray *)colorsForHueGradient
{
    NSMutableArray *colors = [NSMutableArray array];
    for (CGFloat hue = 0.0; hue <= 1.0; hue += 1.0 / 255.0) {
        [colors addObject:(id)[UIColor colorWithHue:hue
                                         saturation:self.firstOtherComponentValue
                                         brightness:self.secondOtherComponentValue
                                              alpha:1.0].CGColor];
    }
    return colors;
}

- (NSArray *)colorsForSaturationGradient
{
    UIColor *startColor = (id)[UIColor colorWithHue:self.firstOtherComponentValue
                                         saturation:0.0
                                         brightness:self.secondOtherComponentValue
                                              alpha:1.0].CGColor;
    
    UIColor *endColor = (id)[UIColor colorWithHue:self.firstOtherComponentValue
                                       saturation:1.0
                                       brightness:self.secondOtherComponentValue
                                            alpha:1.0].CGColor;
    
    return @[ startColor, endColor ];
}

- (NSArray *)colorsForBrightnessGradient
{
    UIColor *startColor = (id)[UIColor colorWithHue:self.firstOtherComponentValue
                                         saturation:self.secondOtherComponentValue
                                         brightness:0.0
                                              alpha:1.0].CGColor;
    
    UIColor *endColor = (id)[UIColor colorWithHue:self.firstOtherComponentValue
                                       saturation:self.secondOtherComponentValue
                                       brightness:1.0
                                            alpha:1.0].CGColor;
    
    return @[ startColor, endColor ];
}

- (NSArray *)colorsForRedGradient
{
    UIColor *startColor = (id)[UIColor colorWithRed:0.0
                                              green:self.firstOtherComponentValue
                                               blue:self.secondOtherComponentValue
                                              alpha:1.0].CGColor;
    
    UIColor *endColor = (id)[UIColor colorWithRed:1.0
                                            green:self.firstOtherComponentValue
                                             blue:self.secondOtherComponentValue
                                            alpha:1.0].CGColor;
    
    return @[ startColor, endColor ];
}

- (NSArray *)colorsForGreenGradient
{
    UIColor *startColor = (id)[UIColor colorWithRed:self.firstOtherComponentValue
                                              green:0.0
                                               blue:self.secondOtherComponentValue
                                              alpha:1.0].CGColor;
    
    UIColor *endColor = (id)[UIColor colorWithRed:self.firstOtherComponentValue
                                            green:1.0
                                             blue:self.secondOtherComponentValue
                                            alpha:1.0].CGColor;
    
    return @[ startColor, endColor ];
}

- (NSArray *)colorsForBlueGradient
{
    UIColor *startColor = (id)[UIColor colorWithRed:self.firstOtherComponentValue
                                              green:self.secondOtherComponentValue
                                               blue:0.0
                                              alpha:1.0].CGColor;
    
    UIColor *endColor = (id)[UIColor colorWithRed:self.firstOtherComponentValue
                                            green:self.secondOtherComponentValue
                                             blue:1.0
                                            alpha:1.0].CGColor;
    
    return @[ startColor, endColor ];
}

- (void)layoutSubviews
{
    self.gradientLayer.frame = self.bounds;
}

@end
