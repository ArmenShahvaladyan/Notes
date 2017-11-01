//
//  PAColorPickerView.h
//  PAColorPicker
//
//  Created by David Shakhbazyan on 11/5/14.
//  Copyright (c) 2014 David Shakhbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAColorPickerView : UIView

@property (strong, nonatomic) UIColor *color;
@property (nonatomic, getter=isPipetteEnabled) BOOL pipetteEnabled;

- (instancetype)initFromNib;

- (void)applyAndClose;

@end
