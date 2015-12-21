//
//  StoryboardUtil.m
//  CodomottoT
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "StoryboardUtil.h"
#import "SignUpViewController.h"

@implementation StoryboardUtil

#pragma mark - stroyboard transition
+ (void)openSignUpViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"SignUpNavigationViewController"];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:YES completion:nil];
}

+ (void)openUserListViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"UserListNavigationViewController"];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:YES completion:nil];
    
}

@end
