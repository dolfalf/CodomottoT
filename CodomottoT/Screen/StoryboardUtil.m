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

@end

#pragma mark - Sign Category
@implementation StoryboardUtil (Sign)
+ (void)openSignInViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignIn" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateInitialViewController];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:animated completion:nil];
    
}

@end

#pragma mark - ISW Category
@implementation StoryboardUtil (ISW)
+ (void)pushSignUpViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ISW" bundle:nil];
    id view_con = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    if (completion) {
        completion(view_con);
    }
    
    [((UIViewController *)owner).navigationController pushViewController:view_con animated:animated];
    
}

+ (void)pushRegistSchoolViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ISW" bundle:nil];
    id view_con = [storyboard instantiateViewControllerWithIdentifier:@"RegistSchoolViewController"];
    
    if (completion) {
        completion(view_con);
    }
    
    [((UIViewController *)owner).navigationController pushViewController:view_con animated:animated];
}

+ (void)pushSchoolListViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ISW" bundle:nil];
    
    id view_con = [storyboard instantiateViewControllerWithIdentifier:@"SchoolListViewController"];
    
    if (completion) {
        completion(view_con);
    }
    
    [((UIViewController *)owner).navigationController pushViewController:view_con animated:animated];
}

+ (void)pushAllowWaitViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ISW" bundle:nil];
    
    id view_con = [storyboard instantiateViewControllerWithIdentifier:@"AllowWaitViewController"];
    
    if (completion) {
        completion(view_con);
    }
    
    [((UIViewController *)owner).navigationController pushViewController:view_con animated:animated];
}

+ (void)pushStartContactViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    id view_con = [storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    
    if (completion) {
        completion(view_con);
    }
    
    //ルートに設定
    [((UIViewController *)owner).navigationController setViewControllers:@[view_con] animated:animated];
    
}

@end

#pragma mark - Setting Category
@implementation StoryboardUtil (Setting)

+ (void)openSettingViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateInitialViewController];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:YES completion:nil];
}

@end

#pragma mark - Contact Category
@implementation StoryboardUtil (Contact)

+ (void)openContactViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contact" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"ContactNavigationController"];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:YES completion:nil];
    
}

@end

#pragma mark - Debug Category
@implementation StoryboardUtil (Debug)

+ (void)openUserListViewController:(id)owner completion:(void(^)(id))completion {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navi_con = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"UserListNavigationController"];
    if (completion) {
        completion(navi_con);
    }
    [((UIViewController *)owner) presentViewController:navi_con animated:YES completion:nil];
    
}

@end

