//
//  UIViewController+VLAddition.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "UIViewController+VLAddition.h"
#import "VLConstants.h"

@implementation UIViewController (VLAddition)

- (void)showAlerWithEmptyFields {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Empty fields!"
                                                                message:kVLFillAllFields
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlerForSigUpWithMessage:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlerForIncorrectUserWithMessage:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:kVLIIncorrectUserTitle
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlerForFilledCharactersWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlerForExistUsername {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@""
                                                                message:kVLExistUserMessage
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAlerWithTitle:(NSString *)title nessage:(NSString *)message {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kVLOk
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ac dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
