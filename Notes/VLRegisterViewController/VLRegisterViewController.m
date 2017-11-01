//
//  VLRegisterViewController.m
//  Notes
//
//  Created by MacBook on 31/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLRegisterViewController.h"
#import "UIViewController+VLAddition.h"
#import "UIColor+VLAddition.h"
#import "VLNoteManager.h"
#import "VLConstants.h"

@interface VLRegisterViewController ()

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorViews;

@property (weak, nonatomic) IBOutlet UITextField *usernameTfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTfield;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic) UITextField *activeTfield;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation VLRegisterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableSignInButton];
    [self registerForKeyboardNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma maek - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTfield = textField;
    [self changeColorOfViewWithTag:textField.tag];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 4:
            [self.passwordTfield becomeFirstResponder];
            return NO;
        default:
            [self changeColorOfViewWithTag:0];
            return YES;
    }
}

#pragma maek - Private api

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 20, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(rect, self.activeTfield.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTfield.frame.origin.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldTextDidChange:(NSNotification*)notification {
    UITextField *tf = notification.object;
    switch (tf.tag) {
        case 4:
            self.username = tf.text;
            break;
        case 5:
            self.password = tf.text;
            break;
    }
    
    if ([self isValidUsername] && [self isValidPassword]) {
        [self enableSignInButton];
    } else {
        [self disableSignInButton];
    }
}

- (void)changeColorOfViewWithTag:(NSInteger)tag {
    for (UIView *elem in self.colorViews) {
        if (elem.tag == tag) {
            elem.backgroundColor = [UIColor selectedFieldColor];
        } else {
            elem.backgroundColor = [UIColor deselectedFieldColor];
        }
    }
}

- (void)removeAllTextsFromFields {
    self.usernameTfield.text = @"";
    self.passwordTfield.text = @"";
}

- (void)enableSignInButton {
    self.registerButton.enabled = YES;
    self.registerButton.alpha = 1;
}

- (void)disableSignInButton {
    self.registerButton.enabled = NO;
    self.registerButton.alpha = 0.7;
}

- (BOOL)isValidUsername {
    return self.usernameTfield.text.length;
}

- (BOOL)isValidPassword {
    return self.passwordTfield.text.length;
}

#pragma mark - Actions

- (IBAction)signUp:(UIButton *)sender {
    [[VLNoteManager sharedInstance] signUpWithUsername:self.username
                                              password:self.password
                                            completion:^(VLUser *user, NSError *error) {
                                                if (error) {
                                                    NSString *message = error.userInfo[NSLocalizedDescriptionKey];
                                                    [self showAlerForSigUpWithMessage:message];
                                                } else {
                                                    [self performSegueWithIdentifier:@"register-notes" sender:nil];
                                                }
                                            }];
}

- (IBAction)goTosignIn:(UIButton *)sender {
    [self removeAllTextsFromFields];
    [self performSegueWithIdentifier:@"signUp-signIn" sender:nil];
}

@end
