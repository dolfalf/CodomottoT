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

#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __FUNCTION__);
    
    [self initControls];
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    if (mgr.isLogin) {
        //園情報を更新
        [mgr loadCurrentSchool];
    }
    
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
        [self transitionLoadViewController];
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __FUNCTION__);
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setToolbarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController setToolbarHidden:NO animated:NO];
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
    [self transitionLoadViewController];
}

- (void)signInFail:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

- (void)signUpSuccess:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    [self transitionLoadViewController];
}

- (void)signUpFail:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Private methods
- (void)initControls {
    NSLog(@"%s", __FUNCTION__);
    
    //REMARK: debug code.
    CGRect frame = [UIScreen mainScreen].bounds;
    UILabel *status_label = [[UILabel alloc] initWithFrame:
                             CGRectMake(0, frame.size.height-13.f, frame.size.width, 13.f)];
    status_label.tag = 998;
    status_label.backgroundColor = [UIColor lightGrayColor];
    status_label.font = [UIFont systemFontOfSize:9.f];
    status_label.textColor = [UIColor whiteColor];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:status_label];
    
}

- (void)transitionLoadViewController {
    
    NSLog(@"%s", __FUNCTION__);
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    //REMARK: 画面遷移処理
    if (mgr.currentCmtUser == nil) {
        //ログインしてない場合はログイン画面へ
        [StoryboardUtil openSignInViewController:self animated:NO completion:nil];
    }else {
        //ログインしているなら下記の条件によって遷移する
        
        BOOL selected_school = mgr.currentSchool==nil?NO:YES;
        
        if (selected_school == NO) {
            //園を選択してない
            if (mgr.userType == UserTypeHeadTeacher) {
                //園長は園生成画面へ遷移する
                [StoryboardUtil pushRegistSchoolViewController:self animated:NO completion:nil];
            }else {
                //先生、保護者は園選択画面へ遷移する
                [StoryboardUtil pushSchoolListViewController:self animated:NO completion:nil];
            }
        }else {
            
            [mgr hasAccessRoleToSchoolInBackground:^(BOOL hasAccessRole) {
                
                if (hasAccessRole == NO) {
                    //園は選択しているがまだ未承認
                    if (mgr.userType == UserTypeHeadTeacher) {
                        //園長は生成と同時に登録するためここには配当なし。??
                        [StoryboardUtil pushStartContactViewController:self animated:NO completion:nil];
                    }else {
                        //先生、保護者は承認待ち画面へ遷移する
                        [StoryboardUtil pushAllowWaitViewController:self animated:NO completion:nil];
                    }
                }else {
                    //園を選択しているかつ承認ももらっていたら
                    [StoryboardUtil pushStartContactViewController:self animated:NO completion:nil];
                }
            }];
        }
    }
    
    //debug code.
    
    //ステータス表示
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UILabel *status_label = [appDelegate.window viewWithTag:998];
    status_label.text = [NSString stringWithFormat:@"  %@", [mgr currentStatusDescription]];
}

@end
