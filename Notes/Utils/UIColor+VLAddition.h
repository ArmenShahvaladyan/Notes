//
//  UIColor+NTAddition.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VLAddition)

- (NSString *)hexString;

+ (UIColor *)selectedFieldColor;
+ (UIColor *)deselectedFieldColor;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
