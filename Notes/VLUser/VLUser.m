//
//  VLUser.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLUser.h"
#import "VLConstants.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface VLUser ()

@property (nonatomic) NSString *username;
@property (nonatomic) NSData *encryptPassword;

@end

@implementation VLUser

#pragma mark - Livecycle

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _encryptPassword = [self encryptPassword:password];
        [[NSUserDefaults standardUserDefaults] setObject:_username forKey:kVLUsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kVLPasswordKey];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kVLUserLogIn];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}


#pragma mark - Private actions

- (NSData *)encryptPassword:(NSString *)password {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSData *encryptData = [RNEncryptor encryptData:passwordData
                                      withSettings:kRNCryptorAES256Settings
                                          password:kVLEncrypOrDecryptPassword
                                             error:&error];
    if (error) {
        NSLog(@"error %@",error.localizedDescription);
        return nil;
    }
    return encryptData;
}

@end
