//
//  VLNoteTableViewCell.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLNote;

@interface VLNoteTableViewCell : UITableViewCell

- (void)fillCellWithData:(VLNote *)note;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTime;
@property (weak, nonatomic) IBOutlet UIImageView *notifivationStateImageView;


@end
