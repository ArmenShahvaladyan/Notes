//
//  UIViewController+VLAddition.h
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (VLAddition)

- (void)showAlerWithEmptyFields;
- (void)showAlerForExistUsername;
- (void)showAlerForIncorrectUserWithMessage:(NSString *)message;
- (void)showAlerForSigUpWithMessage:(NSString *)message;
- (void)showAlerForFilledCharactersWithTitle:(NSString *)title message:(NSString *)message;
- (void)showAlerWithTitle:(NSString *)title nessage:(NSString *)message;

@end
