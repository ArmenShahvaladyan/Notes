//
//  SCPopupViewBase.m
//  picsart
//
//  Created by Monitis on 5/24/13.
//  Copyright (c) 2013 Socialin Inc. All rights reserved.
//

#import "SCPopupViewBase.h"

@interface SCPopupViewBase ()

- (void)initialize;

@end

@implementation SCPopupViewBase

- (void)initialize {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(dismissPopover)
//                                                 name:kSCApplicationWillOpenFromAnotherApplication
//                                               object:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dismissPopover {
    
}

- (void)close {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
