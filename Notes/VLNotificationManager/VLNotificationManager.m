//
//  VLNotificationManager.m
//  Notes
//
//  Created by MacBook on 31/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLNotificationManager.h"
#import "VLNote.h"
#import "VLConstants.h"
#import <UserNotifications/UserNotifications.h>

@interface VLNotificationManager ()

@end

@implementation VLNotificationManager

+ (void)setNotificationWithNote:(VLNote *)note {
    if (note.notificationEnable) {
        NSMutableDictionary *noteInfo = [@{} mutableCopy];
        noteInfo[kVLNotificationIdentifier] = note.noteId;
        noteInfo[@"title"] = note.title;
        noteInfo[@"body"] = note.desc;
        noteInfo[@"color"] = note.hexColor;
        noteInfo[@"date"] = note.date;
        noteInfo[@"nEnable"] = @(note.notificationEnable);
        
        UNMutableNotificationContent *nContent = [[UNMutableNotificationContent alloc] init];
        nContent.title = [NSString localizedUserNotificationStringForKey:note.title arguments:nil];
        nContent.body = [NSString localizedUserNotificationStringForKey:note.desc arguments:nil];
        nContent.sound = [UNNotificationSound defaultSound];
        nContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        nContent.userInfo = [noteInfo copy];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear  |
                                                             NSCalendarUnitMonth |
                                                             NSCalendarUnitDay   |
                                                             NSCalendarUnitHour  |
                                                             NSCalendarUnitMinute) fromDate:note.date];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                                          repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:note.noteId
                                                                              content:nContent
                                                                              trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Local Notification succeeded");
            } else {
                NSLog(@"Local Notification failed");
            }
        }];
    }
}

+ (void)deleteNotificationWithNote:(VLNote *)note {
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[note.noteId]];
}

+ (void)updateNotificationWithNote:(VLNote *)note {
    [VLNotificationManager deleteNotificationWithNote:note];
    [VLNotificationManager setNotificationWithNote:note];
}

@end
