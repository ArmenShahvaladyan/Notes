//
//  VLRealmController.h
//  Notes
//
//  Created by MacBook on 30/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLNote;
@class VLUser;

@interface VLRealmController : NSObject

+ (VLUser *)logInUserWithUsername:(NSString *)username password:(NSString *)password;
+ (void)createUserWithUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)isUserExist:(NSString *)username password:(NSString *)password;
+ (BOOL)isUsernameExist:(NSString *)username;

+ (void)addNote:(VLNote *)note;
+ (void)deleteNoteAtIndex:(NSInteger)idx;
+ (void)updateNoteWithData:(NSDictionary *)data note:(VLNote *)note;
+ (void)replaceNoteAtSourceIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx;

@end
