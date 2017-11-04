//
//  VLWriteNoteViewController.m
//  Notes
//
//  Created by MacBook on 29/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLWriteNoteViewController.h"
#import "SCColorPicker.h"
#import "UIColor+VLAddition.h"
#import "VLNote.h"
#import "VLUser.h"
#import "VLRealmController.h"
#import "VLNotificationManager.h"
#import "VLConstants.h"
#import "MBProgressHUD+VLTost.h"

static const NSInteger pickerViewHeight = 244;

@interface VLWriteNoteViewController () <SCColorPickerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTField;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UIView *selectedColorView;
@property (nonatomic) CGFloat keyboardHeight;


@property (nonatomic) NSString *color;

@end

@implementation VLWriteNoteViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    [self registerForKeyboardNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma maek - handleTapGesture

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    [self done:nil];
    //[self.view endEditing:YES];
}

#pragma mark - ColorPickerDelegate

- (void)colorPicker:(SCColorPicker *)colorPicker didFinishPickColor:(UIColor *)color {
    self.color = [color hexString];
    self.selectedColorView.backgroundColor = color;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *allText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (allText.length <= 30) {
        return YES;
    }
    [self.view endEditing:YES];
    [MBProgressHUD showTostOnView:self.view title:kVLIncorrectLenghtOfNoteTitle];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *allText = [NSString stringWithFormat:@"%@%@",textView.text,text];
    if (allText.length <= 200) {
        return YES;
    }
    [self done:nil];
    [MBProgressHUD showTostOnView:self.view title:kVLIncorrectLenghtOfNote];
    return NO;
}

#pragma mark - Private api

- (void)setUp {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.titleTField.text = self.note.title;
    self.noteTextView.text = self.note.desc;
    self.notificationSwitch.on = self.note.isNotificationEnable;
    self.dateAndTimeLabel.text = [self convertDateToString:self.note.date];
    self.selectedColorView.backgroundColor = [UIColor colorWithHexString:self.note.hexColor];
    self.selectedColorView.layer.cornerRadius = self.selectedColorView.bounds.size.height / 2;
    self.noteTextView.layer.borderWidth = 1;
    self.noteTextView.layer.borderColor = [UIColor colorWithRed:59.f / 255.f
                                                          green:83.f / 255.f
                                                           blue:154.f / 255
                                                          alpha:1].CGColor;
    if (self.note && self.dateAndTimeLabel.text.length > 0) {
        self.notificationSwitch.enabled = YES;
    } else {
        self.notificationSwitch.enabled = NO;
    }
}

- (BOOL)isFieldsEmpty {
    if (self.titleTField.text.length == 0 ) {
        return YES;
    } else if (self.noteTextView.text.length == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)convertDateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY hh:min a"];
    return [formatter stringFromDate:date];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)notification {
    [self closeDataPicker];
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keyboardHeight = keyboardSize.height;
    [UIView animateWithDuration:duration animations:^{
        self.doneButtonBottomConstraint.constant = -(keyboardSize.height + 44);
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    [UIView animateWithDuration:0.4f animations:^{
        self.doneButtonBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (void)textViewTextDidBeginEditing:(NSNotification*)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.keyboardHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame;
    rect.size.height -= self.keyboardHeight;
    CGPoint point = self.noteTextView.frame.origin;
    point.y = CGRectGetMaxY(self.noteTextView.frame);
    if (!CGRectContainsPoint(rect, point)) {
        CGPoint scrollPoint = CGPointMake(0.0, point.y - self.keyboardHeight);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)closeDataPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerViewBottomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (NSDictionary *)noteNewData {
    NSMutableDictionary *data = [@{} mutableCopy];
    NSDate *date = self.dateAndTimeLabel.text.length > 0 ? self.datePicker.date : nil;
    data[@"title"] = self.titleTField.text;
    data[@"note"] = self.noteTextView.text;
    data[@"color"] = self.selectedColorView.backgroundColor.hexString;
    data[@"date"] = date;
    data[@"notificationEnable"] = @(self.notificationSwitch.isOn);
    
    return [data copy];
}

#pragma mark - Actions

- (IBAction)color:(id)sender {
    [self.view endEditing:YES];
    [self closeDataPicker];
    SCColorPicker *colorPicker = [[SCColorPicker alloc] init];
    colorPicker.delegate = self;
    colorPicker.tag = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:colorPicker];
    [colorPicker show];
}

- (IBAction)date:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerViewBottomConstraint.constant = -pickerViewHeight;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    if ([self isFieldsEmpty]) {
        [MBProgressHUD showTostOnView:self.view title:kVLFillAllFields];
    } else {
        if (self.note) {
            NSDictionary *data = [self noteNewData];
            [VLRealmController updateNoteWithData:data note:self.note];
            [VLNotificationManager updateNotificationWithNote:self.note];
        } else {
            NSDate *date = self.dateAndTimeLabel.text.length > 0 ? self.datePicker.date : nil;
            VLNote *newNote = [[VLNote alloc] initWithTitle:self.titleTField.text
                                                       note:self.noteTextView.text
                                                   hexColor:self.color
                                                       date:date
                                                   notState:self.notificationSwitch.isOn];
            [VLRealmController addNote:newNote];
            [VLNotificationManager setNotificationWithNote:newNote];
        }
        
        if (self.onSelectSave) {
            self.onSelectSave();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)done:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
    [self.view endEditing:YES];
}

- (IBAction)doneOfPicker:(id)sender {
    [self closeDataPicker];
    self.notificationSwitch.on = YES;
    self.notificationSwitch.enabled = YES;
    self.dateAndTimeLabel.text = [self convertDateToString:self.datePicker.date];
}

- (IBAction)closeDataPicker:(UIBarButtonItem *)sender {
    self.notificationSwitch.on = NO;
    self.notificationSwitch.enabled = NO;
    self.dateAndTimeLabel.text = @"";
    [self closeDataPicker];
}

@end
