//
//  VLWriteNoteViewController.h
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLNote;

@interface VLWriteNoteViewController : UIViewController

@property (nonatomic,copy) void(^onSelectSave)(void);
@property (nonatomic) VLNote *note;

@end
