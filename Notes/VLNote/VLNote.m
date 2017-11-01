//
//  VLNote.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLNote.h"

@implementation VLNote

- (instancetype)initWithTitle:(NSString *)title
                         note:(NSString *)note
                     hexColor:(NSString *)color
                         date:(NSDate *)date
                     notState:(BOOL)state {
    self = [super init];
    if (self) {
        _noteId = [NSUUID UUID].UUIDString;
        _title = title;
        _desc = note;
        _hexColor = color;
        _date = date;
        _notificationEnable = state;
    }
    return self;
}

@end
