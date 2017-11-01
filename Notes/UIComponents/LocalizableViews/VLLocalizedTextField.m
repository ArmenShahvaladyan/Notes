//
//  VLLocalizedTextField.m
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLLocalizedTextField.h"

@implementation VLLocalizedTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    [self setText:NSLocalizedString(self.text, nil)];
    [self setPlaceholder:NSLocalizedString(self.placeholder, nil)];
}

@end
