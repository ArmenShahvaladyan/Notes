//
//  VLNote.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Realm/Realm.h>

@interface VLNote : RLMObject

- (instancetype)initWithTitle:(NSString *)title
                         note:(NSString *)note
                     hexColor:(NSString *)color
                         date:(NSDate *)date
                     notState:(BOOL)state;

@property (nonatomic) NSString *noteId;//uniq id
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSString *hexColor;
@property (nonatomic) NSDate *date;
@property (nonatomic,getter=isNotificationEnable) BOOL notificationEnable;

@end
