//
//  PAColorIndicator.m
//  PACircleColorPicker
//
//  Created by David Shakhbazyan on 11/3/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import "PAColorIndicator.h"

@implementation PAColorIndicator

- (instancetype)initWithRadius:(CGFloat)radius
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, radius * 4, radius * 4)];
    if (self) {
        self.radius = radius;
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:[self indicatorLayerWithRadius:radius]];
    }
    return self;
}

- (CALayer *)indicatorLayerWithRadius:(CGFloat)radius
{
    CALayer *indicatorLayer = [CALayer layer];
    indicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    indicatorLayer.frame = CGRectMake(0.0, 0.0, radius * 2, radius * 2);
    indicatorLayer.position = CGPointMake(CGRectGetMidY(self.bounds), CGRectGetMidY(self.bounds));
    indicatorLayer.borderColor = [[UIColor whiteColor] CGColor];
    indicatorLayer.borderWidth = radius * 0.1;
    indicatorLayer.cornerRadius = radius;
    indicatorLayer.shadowOffset = CGSizeMake(1, 1);
    indicatorLayer.shadowOpacity = 0.6f;
    indicatorLayer.masksToBounds = YES;
    
    return indicatorLayer;
}

@end
