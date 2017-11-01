//
//  VLRealmController.m
//  Notes
//
//  Created by MacBook on 30/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLRealmController.h"
#import "VLUser.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "VLConstants.h"
#import "VLNoteManager.h"

@interface VLRealmController ()

@end

@implementation VLRealmController

#pragma mark - Public api

+ (void)createUserWithUsername:(NSString *)username password:(NSString *)password {
    VLUser *user = [[VLUser alloc] initWithUsername:username password:password];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] addObject:user];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

+ (VLUser *)logInUserWithUsername:(NSString *)username password:(NSString *)password {
    NSString *s = [NSString stringWithFormat:@"username contains '%@'",username];
    RLMResults *users = [VLUser objectsWhere:s];
    
    for (VLUser *user in users) {
        NSString *existPassword = [self passwordFromEncryptData:user.encryptPassword];
        if ([password isEqualToString:existPassword]) {
            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:kVLUsernameKey];
            [[NSUserDefaults standardUserDefaults] setObject:password forKey:kVLPasswordKey];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kVLUserLogIn];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return user;
        }
    }
    return nil;
}

+ (BOOL)isUsernameExist:(NSString *)username {
    NSString *s = [NSString stringWithFormat:@"username contains '%@'",username];
    RLMResults *users = [VLUser objectsWhere:s];
    
    return users.count;
}

+ (BOOL)isUserExist:(NSString *)username password:(NSString *)password {
    NSString *s = [NSString stringWithFormat:@"username contains '%@'",username];
    RLMResults *users = [VLUser objectsWhere:s];
    
    for (VLUser *user in users) {
        NSString *existPassword = [self passwordFromEncryptData:user.encryptPassword];
        if ([password isEqualToString:existPassword]) {
            return YES;
        }
    }
    return NO;
}

+ (void)addNote:(VLNote *)note {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[VLNoteManager sharedInstance].user.notes addObject:note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

+ (void)updateNoteWithData:(NSDictionary *)data note:(VLNote *)note {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    note.title = data[@"title"];
    note.desc = data[@"note"];
    note.hexColor = data[@"color"];
    note.date = data[@"date"];
    note.notificationEnable = [data[@"notificationEnable"] boolValue];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

+ (void)replaceNoteAtSourceIndex:(NSInteger)sourceIdx toIndex:(NSInteger)destinationIdx {
    VLUser *user = [VLNoteManager sharedInstance].user;
    [[RLMRealm defaultRealm] beginWriteTransaction];
    VLNote *sourceNote = [user.notes objectAtIndex:sourceIdx];
    VLNote *destinationNote = [user.notes objectAtIndex:destinationIdx];
    
    [user.notes replaceObjectAtIndex:sourceIdx withObject:destinationNote];
    [user.notes replaceObjectAtIndex:destinationIdx withObject:sourceNote];
    
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

+ (void)deleteNoteAtIndex:(NSInteger)idx {
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[VLNoteManager sharedInstance].user.notes removeObjectAtIndex:idx];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

#pragma mark - Private api

+ (NSString *)passwordFromEncryptData:(NSData *)data {
    NSError *error = nil;
    NSData *decryptData = [RNDecryptor decryptData:data
                                      withPassword:kVLEncrypOrDecryptPassword
                                             error:&error];
    if (error) {
        NSLog(@"error %@",error.localizedDescription);
        return nil;
    }
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end
