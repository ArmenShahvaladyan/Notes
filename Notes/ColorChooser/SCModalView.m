//
//  SCModalView.m
//  collage
//
//  Created by Instigate CJSC on 9/18/12.
//  Copyright (C) 2012 Socialin Inc. All rights reserved.
//

#import "SCModalView.h"

@interface SCModalView ()
{
    BOOL isClosedByUser;
}

@end

@implementation SCModalView

- (id)initWithNibName:(NSString*)nibName {
    self = [super init];
    if (self) {
        _motionEffectEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.alpha = 0.0;
        closingView = [[UIView alloc] init];
        closingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        closingView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self addSubview:closingView];
        NSArray* subViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        contentView = [subViews objectAtIndex:0];
        contentView.clipsToBounds = YES;
        [self addSubview:contentView];
       // [contentView setMotionEffectsEnabled:YES];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(close:)
//                                                     name:kSCApplicationWillOpenFromAnotherApplication
//                                                   object:nil];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self correctLayout];
}

- (void)correctLayout {
    contentView.center = CGPointMake(self.superview.bounds.size.width / 2,
                                    self.superview.bounds.size.height / 2);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    if (!CGRectContainsPoint(contentView.frame, [touch locationInView:self])) {
        [self cancel:nil];
    }
}

- (void)close {
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;
    [self removeFromSuperview];
}

- (void)close:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished == NO) return;
            //TODO test solution for SCModalView crash.
            if (self.delegate && [self.delegate respondsToSelector:@selector(modalView:isClosedByUser:)]) {
                [self.delegate modalView:self isClosedByUser:isClosedByUser];
            }
            [self removeFromSuperview];
            isClosedByUser = NO;
        }];
    } else {
        if ([self.delegate respondsToSelector:@selector(modalView:isClosedByUser:)]) {
            [self.delegate modalView:self isClosedByUser:isClosedByUser];
        }
        contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        [self removeFromSuperview];
    }
}

- (void)show {
    self.frame = self.superview.bounds;
    closingView.frame = self.bounds;
    contentView.center = self.center;
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        contentView.transform = CGAffineTransformIdentity;
	}];
}

- (IBAction)cancel:(UIButton*)sender {
    isClosedByUser = YES;
    [self close:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
