//
//  SCPaletteView.m
//  collage
//
//  Created by Instigate CJSC on 9/10/12.
//  Copyright (C) 2012 Socialin Inc. All rights reserved.
//

#import "SCColorPicker.h"
#import "PAColorPickerView.h"

@interface SCColorPicker ()

@property (strong, nonatomic) PAColorPickerView *colorPicker;

@end

@implementation SCColorPicker

@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    if (self) {
        self.motionEffectEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.alpha = 0.0;
        closingView = [[UIView alloc] init];
        closingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        closingView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self addSubview:closingView];
        
        self.colorPicker = [[PAColorPickerView alloc] initFromNib];
        contentView = _colorPicker;
        contentView.clipsToBounds = YES;

        [self addSubview:contentView];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    self.colorPicker.color = color;
}

- (void)setPipetteEnabled:(BOOL)pipetteEnabled {
    [self.colorPicker setPipetteEnabled:pipetteEnabled];
}

- (void)applyAndClose{
    [self.colorPicker applyAndClose];
}

- (void)show {
//    if ([UIScreen mainScreen].is4GenPhoneScreen) {
//        [self removeFromSuperview];
//        [[UIApplication sharedApplication].keyWindow addSubview:self];
//        contentView.bounds = CGRectMake(0, 0, 320, 480);
//        [UIView performWithoutAnimation:^{
//            [super show];
//        }];
//    } else {
        [super show];
    //}
}

- (void)close:(BOOL)animated {
//    if ([UIScreen mainScreen].is4GenPhoneScreen) {
//        animated = NO;
//    }
    [super close:animated];
}

- (void)cancel:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerDidCancel:closedByButton:lastChangedColor:)]) {
        [self.delegate colorPickerDidCancel:self closedByButton:NO lastChangedColor:self.colorPicker.color];
    }
    [super cancel:sender];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
