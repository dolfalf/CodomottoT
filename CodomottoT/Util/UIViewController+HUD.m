//
//  UIViewController+HUD.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/12.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showIndicator {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideIndicator {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//hud.mode = MBProgressHUDModeAnnularDeterminate;
//hud.labelText = @"Loading";
//[self doSomethingInBackgroundWithProgressCallback:^(float progress) {
//    hud.progress = progress;
//} completionCallback:^{
//    [hud hide:YES];
//}];
//UI updates should always be done on the main thread. Some MBProgressHUD setters are however considered "thread safe" and can be called from background threads. Those also include setMode:, setCustomView:, setLabelText:, setLabelFont:, setDetailsLabelText:, setDetailsLabelFont: and setProgress:.
//
//If you need to run your long-running task in the main thread, you should perform it with a slight delay, so UIKit will have enough time to update the UI (i.e., draw the HUD) before you block the main thread with your task.
//
//[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//    // Do something...
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//});

@end
