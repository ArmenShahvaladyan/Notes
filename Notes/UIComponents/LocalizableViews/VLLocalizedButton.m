//
//  VLLocalizedButton.m
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLLocalizedButton.h"

@implementation VLLocalizedButton

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.currentAttributedTitle.string.length) {
            id attrDict = [self.currentAttributedTitle attributesAtIndex:0 effectiveRange:nil];
           NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:NSLocalizedString(self.currentAttributedTitle.string, nil) attributes:attrDict];
            [self setAttributedTitle:attributedString forState:UIControlStateNormal];
        } else {
            [self setTitle:NSLocalizedString(self.titleLabel.text, nil)
                  forState:UIControlStateNormal];
        }
    }
    return self;
}

@end
