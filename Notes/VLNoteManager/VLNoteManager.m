//
//  VLNoteManager.m
//  Notes
//
//  Created by MacBook on 31/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLNoteManager.h"
#import "VLRealmController.h"
#import "VLConstants.h"

@interface VLNoteManager ()

@property (nonatomic) VLUser *user;

@end

@implementation VLNoteManager

#pragma mark - sharedInstance

+ (instancetype)sharedInstance {
    static VLNoteManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Private api

- (NSError *)userErrorWithCode:(NSInteger)errorCode message:(NSString *)message {
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
    return  [NSError errorWithDomain:@"com.volo.notes.userAlredyExist"
                                code:errorCode
                            userInfo:[userInfo copy]];
}

#pragma mark - Public api

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(VLUser *user,NSError *error))completion {
    if ([VLRealmController isUserExist:username password:password]) {
        self.user = [VLRealmController logInUserWithUsername:username password:password];
        if (self.user && completion) {
            completion(self.user,nil);
        } else {
            NSError *incorrectUserError = [self userErrorWithCode:kVLIncorrectUserErrorKode
                                                          message:kVLIncorrectUserMessage];
            if (completion) {
                completion(nil,incorrectUserError);
            }
        }
    } else {
        NSError *incorrectUserError = [self userErrorWithCode:kVLIncorrectUserErrorKode
                                                     message:kVLIncorrectUserMessage];
        if (completion) {
            completion(nil,incorrectUserError);
        }
    }
}

- (void)signUpWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(VLUser *user,NSError *error))completion {
    if ([VLRealmController isUsernameExist:username] && completion) {
        NSError *existError = [self userErrorWithCode:kVLUserAlreadyExistErrorKode
                                              message:kVLExistUserMessage];
        completion(nil,existError);
    } else {
        [VLRealmController createUserWithUsername:username password:password];
        self.user = [VLRealmController logInUserWithUsername:username password:password];
        if (self.user && completion) {
            completion(self.user,nil);
        } else {
            NSError *notSignUpError = [self userErrorWithCode:kVLUserCantSignUpErrorKode
                                                      message:kVLUserCantSignUpMessage];
            if (completion) {
                completion(nil,notSignUpError);
            }
        }
    }
}

- (void)signOut {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kVLUsernameKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kVLPasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:kVLUserLogIn];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.user = nil;
}

@end
