//
//  VLEncryptHelper.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLEncryptHelper.h"

@interface VLEncryptHelper ()

@property (nonatomic) SecKeyRef privateKey;

@end

@implementation VLEncryptHelper

+ (instancetype)sharedInstance {
    static VLEncryptHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CFErrorRef error = NULL;
        NSData* tag = [@"com.example.keys.mykey" dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* attributes = @{(id)kSecAttrKeyType:(id)kSecAttrKeyTypeRSA,
                                     (id)kSecAttrKeySizeInBits:@2048,
                                     (id)kSecPrivateKeyAttrs:@{(id)kSecAttrIsPermanent:@YES,
                                                               (id)kSecAttrApplicationTag: tag,},};
        _privateKey = SecKeyCreateRandomKey((__bridge CFDictionaryRef)attributes,&error);
    }
    return self;
}

- (void)encryptPassword:(NSString *)password  completion:(void(^)(NSData *data,NSError *error))completion {
   // NSString *key = @"com.volo.notes.keys.key";
    CFErrorRef error = NULL;
    if (!self.privateKey) {
        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
        // Handle the error. . .
        if (self.privateKey) CFRelease(self.privateKey);
        
        completion(nil,err);
        return;
    }
    SecKeyRef publicKey = SecKeyCopyPublicKey(self.privateKey);
    SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionOAEPSHA512;
    BOOL canEncrypt = SecKeyIsAlgorithmSupported(publicKey,
                                                 kSecKeyOperationTypeEncrypt,
                                                 algorithm);
    NSData* plainText = [@"password" dataUsingEncoding:NSUTF8StringEncoding];
    canEncrypt &= ([plainText length] < (SecKeyGetBlockSize(publicKey)-130));
    
    NSData* cipherText = nil;
    if (canEncrypt) {
        CFErrorRef error = NULL;
        cipherText = (NSData*)CFBridgingRelease(      // ARC takes ownership
                                                SecKeyCreateEncryptedData(publicKey,
                                                                          algorithm,
                                                                          (__bridge CFDataRef)plainText,
                                                                          &error));
        if (!cipherText) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            // Handle the error. . .
            if (publicKey) CFRelease(publicKey);
            if (self.privateKey) CFRelease(self.privateKey);
            completion(nil,err);
            return;
        }
        //if (publicKey) CFRelease(publicKey);
        //if (privateKey) CFRelease(privateKey);
        completion(cipherText,nil);
        return;
    }
    //if (publicKey) CFRelease(publicKey);
    //if (privateKey) CFRelease(privateKey);
    NSError *err = CFBridgingRelease(error);
    completion(nil,err);
    return;
}


- (void)decryptPasswordData:(NSData *)data completion:(void(^)(NSString *password,NSError *error))completion {
    CFErrorRef error = NULL;
    if (!self.privateKey) {
        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
        // Handle the error. . .
        if (self.privateKey) CFRelease(self.privateKey);
        completion(nil,err);
        return;
    }
    SecKeyRef publicKey = SecKeyCopyPublicKey(self.privateKey);
    SecKeyAlgorithm algorithm = kSecKeyAlgorithmRSAEncryptionOAEPSHA512;
    
    BOOL canDecrypt = SecKeyIsAlgorithmSupported(self.privateKey,
                                                 kSecKeyOperationTypeDecrypt,
                                                 algorithm);
    canDecrypt &= ([data length] == SecKeyGetBlockSize(self.privateKey));
    NSData* clearText = nil;
    if (canDecrypt) {
        CFErrorRef error = NULL;
        clearText = (NSData*)CFBridgingRelease(       // ARC takes ownership
                                               SecKeyCreateDecryptedData(self.privateKey,
                                                                         algorithm,
                                                                         (__bridge CFDataRef)data,
                                                                         &error));
        if (!clearText) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            // Handle the error. . .
            if (publicKey) CFRelease(publicKey);
            if (self.privateKey) CFRelease(self.privateKey);
            completion(nil,err);
            return;
        }
        if (publicKey) CFRelease(publicKey);
        if (self.privateKey) CFRelease(self.privateKey);
        completion([[NSString alloc] initWithData:clearText encoding:NSUTF8StringEncoding],nil);
        return;
    }
    
    if (publicKey) CFRelease(publicKey);
    if (self.privateKey) CFRelease(self.privateKey);
    NSError *err = CFBridgingRelease(error);
    completion(nil,err);
    return;
};

@end
