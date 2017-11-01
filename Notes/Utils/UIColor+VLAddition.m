//
//  UIColor+NTAddition.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "UIColor+VLAddition.h"

@implementation UIColor (VLAddition)

- (NSString *)hexString {
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
    }
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor *)selectedFieldColor {
    return [UIColor colorWithRed:59.f / 255.f
                           green:83.f / 255.f
                            blue:154.f / 255.f
                           alpha:1.f];
}

+ (UIColor *)deselectedFieldColor {
    UIColor *color = [UIColor colorWithRed:170.f / 255.f
                                     green:170.f / 255.f
                                      blue:170.f / 255.f
                                     alpha:1.f];
    return color;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1];
}


@end
