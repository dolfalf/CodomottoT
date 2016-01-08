//
//  UIViewController+Alert.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/08.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "SIAlertView.h"

@implementation UIViewController (Alert)

- (void)showConfirmAlertView:(NSString *)message block:(void(^)(void))block {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:message];
    
    [alertView addButtonWithTitle:@"確認"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              
                              if (block) {
                                  block();
                              }
                          }];
    
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    [alertView show];
    
}

@end
