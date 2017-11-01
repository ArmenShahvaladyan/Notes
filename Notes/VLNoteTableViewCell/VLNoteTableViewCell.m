//
//  VLNoteTableViewCell.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLNoteTableViewCell.h"
#import "VLNote.h"
#import "UIColor+VLAddition.h"

@implementation VLNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colorView.layer.cornerRadius = self.colorView.bounds.size.height / 2;
}

- (void)fillCellWithData:(VLNote *)note {
    self.titleLabel.text = note.title;
    self.descriptionLabel.text = note.desc;
    self.dateAndTime.text = [self convertDateToString:note.date];
    [self.colorView setBackgroundColor:[UIColor colorWithHexString:note.hexColor]];
    if (note.isNotificationEnable) {
        self.notifivationStateImageView.image = [UIImage imageNamed:@"checked"];
    } else {
        self.notifivationStateImageView.image = [UIImage imageNamed:@"unckecked"];
    }
}

- (NSString *)convertDateToString:(NSDate *)date {
    if (!date) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:min a"];
    
    return [formatter stringFromDate:date];
}

@end
