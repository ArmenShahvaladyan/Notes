//
//  VLNotificationManager.h
//  Notes
//
//  Created by MacBook on 31/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLNote;

@interface VLNotificationManager : NSObject

+ (void)setNotificationWithNote:(VLNote *)note;
+ (void)deleteNotificationWithNote:(VLNote *)note;
+ (void)updateNotificationWithNote:(VLNote *)note;

@end
