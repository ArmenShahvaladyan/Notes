//
//  SCModalView.h
//  collage
//
//  Created by Instigate CJSC on 9/18/12.
//  Copyright (C) 2012 Socialin Inc. All rights reserved.
//

#import "SCPopupViewBase.h"

@class SCModalView;

@protocol SCModalViewDelegate <NSObject>

@optional
- (void)modalView:(SCModalView *)modalView isClosedByUser:(BOOL)byUser;

@end

@interface SCModalView : SCPopupViewBase
{
    UIView *contentView;
    UIView *closingView;
}

@property (nonatomic, weak) id<SCModalViewDelegate> delegate;

@property (nonatomic) BOOL motionEffectEnabled;

- (IBAction)cancel:(UIButton *)sender;

- (id)initWithNibName:(NSString *)nibName;

- (void)close:(BOOL)animated;

- (void)show;

//- (void)correctLayout;

@end
