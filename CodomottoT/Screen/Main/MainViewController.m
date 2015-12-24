//
//  MainViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/24.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "MainViewController.h"
#import "CMTParseManager.h"
#import "StoryboardUtil.h"

#import "SignInViewController.h"
#import "SignUpViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __FUNCTION__);
    
    [self initControls];
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signInSuccess:)
                                                 name:kSignInViewControllerNotificationSignInSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signInFail:)
                                                 name:kSignInViewControllerNotificationSignInSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signUpSuccess:)
                                                 name:kSignUpViewControllerNotificationSignUpSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(signUpFail:)
                                                 name:kSignUpViewControllerNotificationSignUpFail
                                               object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self transitionStartViewController];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
    
    
}

- (void)dealloc {
    
    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kSignInViewControllerNotificationSignInSuccess
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:kSignInViewControllerNotificationSignInFail
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kSignUpViewControllerNotificationSignUpSuccess
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kSignUpViewControllerNotificationSignUpFail
                                                  object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Notification callback
- (void)signInSuccess:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    [self transitionStartViewController];
}

- (void)signInFail:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)signUpSuccess:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    [self transitionStartViewController];
}

- (void)signUpFail:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Private methods
- (void)initControls {
    NSLog(@"%s", __FUNCTION__);
}

- (void)transitionStartViewController {
    NSLog(@"%s", __FUNCTION__);
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    //REMARK: ログインチェック
    if (mgr.loginUser == nil) {
        //ログインしてない場合はログイン画面へ
        [StoryboardUtil openSignInViewController:self animated:NO completion:nil];
    }else {
        //ログインしているなら下記の条件によって遷移する
        
        BOOL selected_school = (mgr.loginUser.cmtWorkSchool)==nil?NO:YES;
        UserType login_user_type = (UserType)[mgr.loginUser.cmtUserType integerValue];
        
        if (selected_school == NO) {
            //園を選択してない
            if (login_user_type == UserTypeHeadTeacher) {
                //園長は園生成画面へ遷移する
                [StoryboardUtil pushRegistSchoolViewController:self animated:NO completion:nil];
            }else {
                //先生、保護者は園選択画面へ遷移する
                [StoryboardUtil pushSchoolListViewController:self animated:NO completion:nil];
            }
        }else if (selected_school == YES && [mgr hasAccessRoleToSchool] == NO) {
            //園は選択しているがまだ未承認
            if (login_user_type == UserTypeHeadTeacher) {
                //園長は生成と同時に登録するためここには配当なし。
            }else {
                //先生、保護者は承認待ち画面へ遷移する
                [StoryboardUtil pushAllowWaitViewController:self animated:NO completion:nil];
            }
        }else if (selected_school == YES && [mgr hasAccessRoleToSchool] == YES) {
            //園を選択しているかつ承認ももらっていたら
            [StoryboardUtil pushStartContactViewController:self animated:NO completion:nil];
            
        }else {
            //ステータスが不明
        }
        
    }
}

@end
