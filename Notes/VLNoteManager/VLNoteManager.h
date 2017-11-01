//
//  VLNoteManager.h
//  Notes
//
//  Created by MacBook on 31/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VLUser;

@interface VLNoteManager : NSObject

@property (nonatomic, readonly) VLUser *user;

+ (instancetype)sharedInstance;

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(VLUser *user,NSError *error))completion;
- (void)signUpWithUsername:(NSString *)username
                  password:(NSString *)password
                completion:(void(^)(VLUser *user,NSError *error))completion;
- (void)signOut;

@end
