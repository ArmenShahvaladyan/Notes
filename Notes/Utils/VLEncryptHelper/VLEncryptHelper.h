//
//  VLEncryptHelper.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLEncryptHelper : NSObject

+ (instancetype)sharedInstance;
- (void)encryptPassword:(NSString *)password  completion:(void(^)(NSData *data,NSError *error))completion;
- (void)decryptPasswordData:(NSData *)data completion:(void(^)(NSString *password,NSError *error))completion;

@end
