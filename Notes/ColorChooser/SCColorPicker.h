//
//  SCPaletteView.h
//  collage
//
//  Created by Instigate CJSC on 9/10/12.
//  Copyright (C) 2012 Socialin Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SCModalView.h"

@class SCColorPicker;

@protocol SCColorPickerDelegate <SCModalViewDelegate>

- (void)colorPicker:(SCColorPicker*)colorPicker didFinishPickColor:(UIColor*)color;

@optional

- (void)colorPickerDidSelectPipette:(SCColorPicker *)colorPicker;
- (void)colorPickerDidCancel:(SCColorPicker *)colorPicker closedByButton:(BOOL)closedByButton lastChangedColor:(UIColor*)color;
@end

@interface SCColorPicker : SCModalView

@property (nonatomic, getter=isPipetteEnabled) BOOL pipetteEnabled;
@property (nonatomic, weak) id <SCColorPickerDelegate> delegate;

- (void)setColor:(UIColor *)color;

- (void)applyAndClose;

@end
