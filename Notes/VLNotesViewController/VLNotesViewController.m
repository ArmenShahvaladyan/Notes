//
//  VLNotesViewController.m
//  Notes
//
//  Created by MacBook on 28/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "VLNotesViewController.h"
#import "VLNoteTableViewCell.h"
#import "VLWriteNoteViewController.h"
#import "VLRealmController.h"
#import "VLNotificationManager.h"
#import "VLNoteManager.h"
#import "VLUser.h"

@interface VLNotesViewController () <UITableViewDataSource>

@property (nonatomic) RLMArray *notes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarItem;

@end

@implementation VLNotesViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notes = [VLNoteManager sharedInstance].user.notes;
    
    if (self.notes.count > 0) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VLNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
    VLNote *note = self.notes[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell fillCellWithData:note];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectNoteAtIndex:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [VLRealmController replaceNoteAtSourceIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [VLNotificationManager deleteNotificationWithNote:[VLNoteManager sharedInstance].user.notes[indexPath.row]];
        [VLRealmController deleteNoteAtIndex:indexPath.item];
        [tableView reloadData];
    }
}

#pragma mark - Private api

- (void)selectNoteAtIndex:(NSInteger)index {
    [self goToWriteNoteViewControllerWithNote:self.notes[index]];
}

- (void)goToWriteNoteViewControllerWithNote:(VLNote *)note {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VLWriteNoteViewController *vc = [sb instantiateViewControllerWithIdentifier:@"VLWriteNoteViewControllerId"];
    vc.note = note;
    __weak VLNotesViewController *weakSelf = self;
    vc.onSelectSave = ^{
        __strong VLNotesViewController *strongSelf = weakSelf;
        strongSelf.notes = [VLNoteManager sharedInstance].user.notes;
        [strongSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (IBAction)addNote:(id)sender {
    [self goToWriteNoteViewControllerWithNote:nil];
}

- (IBAction)edit:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    } else {
        sender.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
}

- (IBAction)signOut:(id)sender {
    for (VLNote *note in [VLNoteManager sharedInstance].user.notes) {
        [VLNotificationManager deleteNotificationWithNote:note];
    }
    [[VLNoteManager sharedInstance] signOut];
    [self performSegueWithIdentifier:@"note-logIn" sender:nil];
}

@end
