//
//  PASliderColorView.h
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/11/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PAColorSliderType) {
    PAColorSliderTypeHue,
    PAColorSliderTypeSaturation,
    PAColorSliderTypeBrightness,
    PAColorSliderTypeRed,
    PAColorSliderTypeGreen,
    PAColorSliderTypeBlue
};

@interface PASliderColorView : UIView

@property (nonatomic, assign) PAColorSliderType type;
@property (nonatomic, assign) CGFloat firstOtherComponentValue;
@property (nonatomic, assign) CGFloat secondOtherComponentValue;

- (void)update;

@end
