//
//  PARhombView.m
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 10/29/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PARhombView.h"
#import <Accelerate/Accelerate.h>

#define INSET 10

@interface PARhombView ()

@property (strong, nonatomic) CALayer *blackGradientLayer;
@property (strong, nonatomic) CALayer *whiteGradientLayer;

@end

@implementation PARhombView

- (instancetype)initWithSize:(CGFloat)size color:(UIColor *)color {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, size, size)];
    if (self) {
        _size = size;
        
        self.backgroundColor = color;
        self.layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
        
        [self.layer addSublayer:self.whiteGradientLayer];
        [self.layer addSublayer:self.blackGradientLayer];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (UIColor *)color {
    return self.backgroundColor;
}

- (CALayer *)whiteGradientLayer {
    if (!_whiteGradientLayer) {
        _whiteGradientLayer = [self layerWithAlphaMask];
        _whiteGradientLayer.backgroundColor = [UIColor whiteColor].CGColor;
//        _whiteGradientLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
    }
    return _whiteGradientLayer;
}

- (CALayer *)blackGradientLayer {
    if (!_blackGradientLayer) {
        _blackGradientLayer = [self layerWithAlphaMask];
        _blackGradientLayer.backgroundColor = [UIColor blackColor].CGColor;
        _blackGradientLayer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    }
    return _blackGradientLayer;
}

- (CALayer *)layerWithAlphaMask {
    
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.mask = [CALayer layer];
    layer.mask.frame = layer.bounds;
    CGImageRef alphaImage = [self newImageWithAlphaGradientRect];
    layer.mask.contents = (__bridge id)alphaImage;
    
    CGImageRelease(alphaImage);
    
    return layer;
}

- (CGImageRef)newImageWithAlphaGradientRect {
    
    //Processing pixel data
    vImagePixelCount width = self.size;
    vImagePixelCount height = width;
    
    Pixel_8 *data = malloc(width * height * sizeof(Pixel_8));
    
    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            data[i + j * width] = 255 - ((CGFloat)i / width) * 255.0;
        }
    }
    
    //Creating pixel buffer
    vImage_Buffer pixelBuffer;
    pixelBuffer.width = width;
    pixelBuffer.height = height;
    pixelBuffer.data = data;
    pixelBuffer.rowBytes = width * sizeof(Pixel_8);
    
    //Creating image from pixel buffer
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaOnly;
    
    CGContextRef bitmapContext = CGBitmapContextCreate(pixelBuffer.data,
                                                       pixelBuffer.width,
                                                       pixelBuffer.height,
                                                       8,
                                                       pixelBuffer.rowBytes,
                                                       colorSpace,
                                                       bitmapInfo);
    
    CGImageRef alphaImage = CGBitmapContextCreateImage(bitmapContext);
    
    free(data);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmapContext);
    
    return alphaImage;
}

- (CGPoint)indicatorCenterForTouchLocation:(CGPoint)point {
    CGPoint validPoint = [self validatePoint:point];
    
    self.saturationValue = [self saturationValueForPoint:validPoint];
    self.brightnessValue = [self brightnessValueForPoint:validPoint];
        
    return [self convertPoint:validPoint toView:self.superview];
}

- (CGPoint)indicatorCenterForSaturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    self.saturationValue = saturation;
    self.brightnessValue = brightness;
    
    CGPoint point = [self pointForSaturation:saturation brightness:brightness];
    
    return [self convertPoint:point toView:self.superview];
}

- (CGFloat)saturationValueForPoint:(CGPoint)point {
    return fabs(point.x / self.bounds.size.width);
}

- (CGFloat)brightnessValueForPoint:(CGPoint)point {
    return fabs(1.0 - point.y / self.bounds.size.height);
}

- (CGPoint)pointForSaturation:(CGFloat)saturation brightness:(CGFloat)brightness {
    return CGPointMake(saturation * self.bounds.size.width,
                       (1.0 - brightness) * self.bounds.size.height);
}

- (CGPoint)validatePoint:(CGPoint)point {
    CGPoint pointInView = [self.superview convertPoint:point toView:self];
    
    if (CGRectContainsPoint(self.bounds, pointInView)) {
        
        return pointInView;
    }
    else {
        CGFloat squareSize = self.bounds.size.width / 2;
        pointInView.x -= squareSize;
        pointInView.y -= squareSize;
        
        CGFloat scale = MIN(squareSize / fabs(pointInView.x), squareSize / fabs(pointInView.y));
        
        CGPoint pointOnRhomb;
        pointOnRhomb.x = scale * pointInView.x;
        pointOnRhomb.y = scale * pointInView.y;
        
        pointOnRhomb.x += squareSize;
        pointOnRhomb.y += squareSize;
                
        return pointOnRhomb;
    }
}

@end
