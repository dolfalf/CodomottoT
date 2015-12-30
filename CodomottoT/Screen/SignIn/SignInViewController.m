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

NSString* const kSignInViewControllerNotificationSignInSuccess  = @"signInViewControllerNotificationSignInSuccess";
NSString* const kSignInViewControllerNotificationSignInFail     = @"signInViewControllerNotificationSignInFail";

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
    self.title = @"サインイン";
    
    //navibar.
    UIBarButtonItem *signup_button = [[UIBarButtonItem alloc] initWithTitle:@"新規登録"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(signUpButtonTouched:)];
    self.navigationItem.rightBarButtonItems = @[signup_button];
    
}

#pragma mark - private methods

- (void)updateStatusLabel {
    
    CMTParseManager *manager = [CMTParseManager sharedInstance];
    NSLog(@"%s, loginUser[%@]", __FUNCTION__, manager.currentUser);
    
    if (manager.isLogin) {
        _statusLabel.text = [NSString stringWithFormat:@"login User[%@]", manager.currentUser.username];
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
    if (manager.currentUser != nil) {
        //logoutしてから利用可能
        return;
        
    }
    
    //SignUp
    [StoryboardUtil pushSignUpViewController:self animated:YES completion:nil];
    
}

- (IBAction)loginButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    [mgr signIn:_inputLoginId.text password:_inputPassword.text block:^(NSError *error) {
        
        if (error==nil) {
            NSLog(@"login success");
            //画面遷移
            [self dismissViewControllerAnimated:YES completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kSignInViewControllerNotificationSignInSuccess object:nil];
            }];
            
        }else {
            NSLog(@"login failed.");
            [self showAlertMessage:@"login failed."];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSignInViewControllerNotificationSignInFail object:nil];
        }
    }];
    
}

@end
