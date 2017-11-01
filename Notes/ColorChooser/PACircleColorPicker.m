//
//  PACircleColorPicker.m
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 10/24/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PACircleColorPicker.h"
#import "PAHueDonutView.h"
#import "PARhombView.h"
#import "PAColorIndicator.h"

#define START_ANGLE 0.0
#define END_ANGLE (2 * M_PI + START_ANGLE)

@interface PACircleColorPicker()

@property (strong, nonatomic) PARhombView *rhombView;
@property (strong, nonatomic) PAHueDonutView *hueDonutView;

@property (strong, nonatomic) PAColorIndicator *hueIndicator;
@property (strong, nonatomic) PAColorIndicator *saturationBrightnessIndicator;

@end

@implementation PACircleColorPicker

@synthesize color = _color;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _radius = (self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width / 2 : self.bounds.size.height / 2);
        _donutWidth = _radius * 0.3f;
        [self _init];
        
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius donutWidth:(CGFloat)donutWidth {
    self = [self initWithFrame:CGRectMake(0.0, 0.0, radius * 2, radius * 2)];
    if (self) {
        _radius = radius;
        _donutWidth = donutWidth;
        [self _init];
        
        return self;
    }
    return nil;
}

- (void)_init {
    self.layer.cornerRadius = self.radius;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.hueDonutView];
    [self addSubview:self.rhombView];
    [self addSubview:self.hueIndicator];
    [self addSubview:self.saturationBrightnessIndicator];

    self.hue = 135.0 / 255;
    self.saturation = 1.0;
    self.brightness = 1.0;
    
    [self updateIndicators];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    CGFloat hue, saturation, brightness;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:NULL];
    
    self.hue = hue;
    self.saturation = saturation;
    self.brightness = brightness;
    
    [self updateIndicators];
}

- (UIColor *)color {
    _color = [UIColor colorWithHue:_hue saturation:_saturation brightness:_brightness alpha:1.0];
    
    return _color;
}

- (void)setHue:(CGFloat)hue {
    _hue = hue;
    self.rhombView.color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
}

#pragma mark - Subviews

- (PAHueDonutView *)hueDonutView {
    if (!_hueDonutView) {
        _hueDonutView = [[PAHueDonutView alloc] initWithRadius:self.radius
                                                      donutWidth:self.donutWidth
                                                      startAngle:START_ANGLE
                                                        endAngle:END_ANGLE];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveHueIndicator:)];
        [_hueDonutView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveHueIndicator:)];
        [_hueDonutView addGestureRecognizer:pan];
        
    }
    return _hueDonutView;
}

- (PARhombView *)rhombView {
    if (!_rhombView) {
        UIColor *color = [UIColor colorWithHue:0.0 saturation:1.0 brightness:1.0 alpha:1.0];
        CGFloat radius = self.radius - self.donutWidth;
        CGFloat size = sqrtf(2 * radius * radius) - self.saturationBrightnessIndicator.radius * 2;
        _rhombView = [[PARhombView alloc] initWithSize:size
                                                 color:color];
        _rhombView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveSaturationBrightnessIndicator:)];
        [_rhombView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSaturationBrightnessIndicator:)];
        [_rhombView addGestureRecognizer:pan];
    }
    return _rhombView;
}

- (PAColorIndicator *)hueIndicator {
    if (!_hueIndicator) {
        _hueIndicator = [[PAColorIndicator alloc] initWithRadius:self.donutWidth / 2 - 1];
        _hueIndicator.center = CGPointMake(CGRectGetMaxX(self.bounds) - self.donutWidth / 2, CGRectGetMidY(self.bounds));
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveHueIndicator:)];
        [_hueIndicator addGestureRecognizer:longPress];
        _hueIndicator.userInteractionEnabled = NO;
    }
    return _hueIndicator;
}

- (PAColorIndicator *)saturationBrightnessIndicator {
    if (!_saturationBrightnessIndicator) {
        _saturationBrightnessIndicator = [[PAColorIndicator alloc] initWithRadius:self.donutWidth / 4];
        _saturationBrightnessIndicator.center = self.rhombView.center;
        _saturationBrightnessIndicator.userInteractionEnabled = NO;
    }
    return _saturationBrightnessIndicator;

}

#pragma mark - Gesture actions

- (void)moveHueIndicator:(UIPanGestureRecognizer *)sender {
    [self animateTouchOnIndicator:_hueIndicator withGesture:sender];
    CGPoint touchLocation = [sender locationInView:self];
    
    self.hue = [_hueDonutView hueValueForTouchLocation:touchLocation];
    _hueIndicator.center = [_hueDonutView indicatorCenterForHueValue:_hue];
    
    float maxValue = 100;
    float minValue = 1;
    
    if (roundf((float)_saturation * maxValue) < minValue ||
        roundf((float)_brightness * maxValue) < minValue) {
        _saturation = 1.0;
        _brightness = 1.0;
        
        [self updateIndicators];
    }

    [self.delegate colorPicker:self didSelectColorWithHue:_hue saturation:_saturation brightness:_brightness];
}

- (void)moveSaturationBrightnessIndicator:(UIPanGestureRecognizer *)sender {
    [self animateTouchOnIndicator:_saturationBrightnessIndicator withGesture:sender];
    
    CGPoint touchLocation = [sender locationInView:self];
    _saturationBrightnessIndicator.center = [_rhombView indicatorCenterForTouchLocation:touchLocation];
    
    self.saturation = _rhombView.saturationValue;
    self.brightness = _rhombView.brightnessValue;
    
//    [self.delegate colorPicker:self didSelectColor:self.color];
    [self.delegate colorPicker:self didSelectColorWithHue:_hue saturation:_saturation brightness:_brightness];
}

- (void)animateTouchOnIndicator:(PAColorIndicator *)indicator withGesture:(UIGestureRecognizer *)gesture {
    if((gesture.state == UIGestureRecognizerStateBegan) || (gesture.state == UIGestureRecognizerStateChanged)) {
        [UIView animateWithDuration:0.1 animations:^ {
            indicator.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.1 animations:^ {
            indicator.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)updateIndicators {
    _hueIndicator.center = [self.hueDonutView indicatorCenterForHueValue:_hue];
    _saturationBrightnessIndicator.center = [self.rhombView indicatorCenterForSaturation:_saturation
                                                                              brightness:_brightness];
}

@end
