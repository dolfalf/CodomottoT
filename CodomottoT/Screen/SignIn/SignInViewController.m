//
//  SignInViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignInViewController.h"
#import "CMTParseManager.h"
#import "SIAlertView.h"
#import "StoryboardUtil.h"

@interface SignInViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputLoginId;
@property (nonatomic, weak) IBOutlet UITextField *inputPassword;


@end

@implementation SignInViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateStatusLabel];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"Sign In";
    
    // スペーサを生成する
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
    
    //toolbar.
    UIBarButtonItem *signup_button = [[UIBarButtonItem alloc] initWithTitle:@"SignUp"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(signUpButtonTouched:)];
    
    UIBarButtonItem *logout_button = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(logoutButtonTouched:)];
    
    UIBarButtonItem *userlist_button = [[UIBarButtonItem alloc] initWithTitle:@"UserList"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(userlistButtonTouched:)];
    
    self.toolbarItems = @[signup_button, logout_button,spacer, userlist_button];
    
}

#pragma mark - private methods

- (void)updateStatusLabel {
    
    CMTParseManager *manager = [CMTParseManager sharedInstance];
    NSLog(@"%s, loginUser[%@]", __FUNCTION__, manager.loginUser);
    
    if (manager.isLogin) {
        _statusLabel.text = [NSString stringWithFormat:@"login User[%@]", manager.loginUser.username];
    }else {
        _statusLabel.text = @"Not logined.";
    }
    
}

- (void)showAlertMessage:(NSString *)message {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:message];
    
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                          }];
/*
    [alertView addButtonWithTitle:@"Button2"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button2 Clicked");
                          }];
    [alertView addButtonWithTitle:@"Button3"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button3 Clicked");
                          }];
*/
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

#pragma mark - Action
- (void)signUpButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    CMTParseManager *manager = [CMTParseManager sharedInstance];
    //login状態をチェック
    if (manager.loginUser != nil) {
        //logout処理
        
    }
    
    //SignUp遷移
    [StoryboardUtil openSignUpViewController:self completion:nil];
    
    
}

- (void)logoutButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [[CMTParseManager sharedInstance] logoutCurrentUserWithCompletion:^(BOOL isSucceeded, NSError *resultError) {
        if (isSucceeded) {
            NSLog(@"logout success");
            [self showAlertMessage:@"logout success"];
        }else {
            NSLog(@"logout failed.");
            [self showAlertMessage:@"logout failed"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateStatusLabel];
        });
        
    }];
    
}

- (IBAction)loginButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [[CMTParseManager sharedInstance] loginWithUserEmailAddress:_inputLoginId.text
                                                   withPassword:_inputPassword.text
                                                 withCompletion:^(BOOL isSucceeded, NSError *resultError) {
                                                     
                                                     if (isSucceeded) {
                                                         NSLog(@"login success");
                                                         //画面遷移
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [self performSegueWithIdentifier:@"SchoolListSegue" sender:self];
                                                         });
                                                         
                                                         
                                                     }else {
                                                         NSLog(@"login failed.");
                                                         [self showAlertMessage:@"login failed."];

                                                     }
                                                     
                                                   }];
    
}

- (void)userlistButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [StoryboardUtil openUserListViewController:self completion:nil];
}

@end
