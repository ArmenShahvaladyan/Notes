//
//  VLLocalizedLabel.m
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLLocalizedLabel.h"

@implementation VLLocalizedLabel

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (self.attributedText.string.length) {
            id attrDict = [self.attributedText attributesAtIndex:0 effectiveRange:nil];
            NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:NSLocalizedString(self.attributedText.string, nil) attributes:attrDict];
            [self setAttributedText:attributedString];
        } else {
            self.text = NSLocalizedString(self.text, nil);
        }
        
    }
    return self;
}

@end
