//
//  AppDelegate.m
//  Notes
//
//  Created by MacBook on 27/10/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "AppDelegate.h"
#import "VLUser.h"
#import "VLConstants.h"
#import "VLNoteManager.h"
#import "VLNotificationManager.h"
#import "VLLogInViewController.h"
#import "VLNotesViewController.h"
#import "VLWriteNoteViewController.h"
#import "UIViewController+VLAddition.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerForRemoteNotification];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BOOL isLogIn = [[[NSUserDefaults standardUserDefaults] objectForKey:kVLUserLogIn] boolValue];
    if (isLogIn) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kVLUsernameKey];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kVLPasswordKey];
        VLNotesViewController *vc = [sb instantiateViewControllerWithIdentifier:@"VLNotesViewControllerId"];
        [[VLNoteManager sharedInstance] signInWithUsername:username password:password completion:^(VLUser *user, NSError *error) {
            if (error) {
                NSLog(@"can not sign in %@",error.description);
                //TO-DO
            }
        }];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = navController;
    } else {
        VLLogInViewController *vc = [sb instantiateViewControllerWithIdentifier:@"VLLogiInViewControllerId"];
        self.window.rootViewController = vc;
    }
    
    return YES;
}

- (void)registerForRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        [uncenter setDelegate:(id)self];
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                         [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    });
                                }];
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                //TODO:
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                //TODO:
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                //TODO:
            }
        }];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *noteInfo = response.notification.request.content.userInfo;
    VLNote *existNote;
    for (VLNote *note in [VLNoteManager sharedInstance].user.notes) {
        if ([note.noteId isEqualToString:noteInfo[kVLNotificationIdentifier]]) {
            existNote = note;
            break;
        }
    }
    
    [VLNotificationManager deleteNotificationWithNote:existNote];

    NSString *title = noteInfo[@"title"];
    NSString *message = noteInfo[@"body"];
    [UIApplication sharedApplication].applicationIconBadgeNumber -= 1;

    UIViewController *topVc = [self getTopViewController];
    [topVc showAlerWithTitle:title nessage:message];
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionBadge);
}

- (UIViewController *)getTopViewController {
    UIViewController *topViewController = [[UIApplication sharedApplication].delegate.window rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
