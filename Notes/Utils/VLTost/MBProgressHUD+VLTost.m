//
//  MBProgressHUD+VLTost.m
//  Notes
//
//  Created by MacBook on 04/11/2017.
//  Copyright © 2017 Armen. All rights reserved.
//

#import "MBProgressHUD+VLTost.h"

@implementation MBProgressHUD (VLTost)

+ (void)showTostOnView:(UIView *)v title:(NSString *)title {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:v animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
}

@end
