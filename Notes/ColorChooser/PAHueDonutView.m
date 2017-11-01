//
//  PAHueDonutView.m
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 11/3/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PAHueDonutView.h"
#import <UIKit/UIKit.h>

@implementation PAHueDonutView

- (instancetype)initWithRadius:(CGFloat)radius
                    donutWidth:(CGFloat)donutWidth
                    startAngle:(CGFloat)startAngle
                      endAngle:(CGFloat)endAngle {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, radius * 2, radius * 2)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _radius = radius;
        _donutWidth = donutWidth;
        _startAngle = startAngle;
        _endAngle = endAngle;
        

        
        self.layer.mask = [self donutMaskWithInset:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGContextSetLineWidth(ctx, self.donutWidth);
    CGContextSetAllowsAntialiasing(ctx, NO);
    CGContextSetShouldAntialias(ctx, YES);
    
    NSUInteger interstices = 360;
    CGFloat previousAngle = self.startAngle;
    CGFloat destinationAngle = previousAngle;
    CGFloat hue = 0.0;
    
    do {
        destinationAngle += (self.endAngle - self.startAngle) / interstices;
        CGContextAddArc(ctx, center.x, center.y, self.radius - self.donutWidth / 2, previousAngle, destinationAngle, NO);
        
        hue += 1.0/ interstices;
        UIColor *color = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
        CGContextSetStrokeColorWithColor(ctx, color.CGColor);
        CGContextStrokePath(ctx);
        
        previousAngle = destinationAngle;
        
    } while (destinationAngle <= self.startAngle + (self.endAngle - self.startAngle));
    
    
}

- (CAShapeLayer *)donutMaskWithInset:(CGFloat)inset {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *outerCirclePath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:_radius - inset
                                                         startAngle:0.0
                                                           endAngle:2 * M_PI
                                                          clockwise:YES];
    
    
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:center radius:_radius - _donutWidth + inset
                     startAngle:0.0
                       endAngle:2 * M_PI
                      clockwise:YES];
    
    [outerCirclePath appendPath:innerCirclePath];
    
    CAShapeLayer *donutMask = [CAShapeLayer layer];
    donutMask.path = outerCirclePath.CGPath;
    donutMask.fillRule = kCAFillRuleEvenOdd;
    
    return donutMask;
}

- (CGPoint)indicatorCenterForHueValue:(CGFloat)hue {
    CGFloat hueInRadians = hue * (2 * M_PI);
    CGFloat radius = self.radius - self.donutWidth / 2;
    CGPoint indicatorCenter = CGPointMake(self.center.x + (cosf(hueInRadians) * radius),
                                          self.center.y + (sinf(hueInRadians) * radius));
    return indicatorCenter;
}

- (CGFloat)hueValueForTouchLocation:(CGPoint)point {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGFloat hueInRadians = (M_PI - atan2f(point.y - self.center.y,
                                          center.x - point.x));
    CGFloat hueValue = hueInRadians / (2 * M_PI);
    
    return hueValue;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGPathRef maskPath = ((CAShapeLayer *)self.layer.mask).path;
    if (CGPathContainsPoint(maskPath, 0, point, true)) {
        return YES;
    }
    return NO;
}

@end
