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

@property (nonatomic, weak) IBOutlet UILabel *loginTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *passwordTitleLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputLoginId;
@property (nonatomic, weak) IBOutlet UITextField *inputPassword;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;


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
    
    //control initailze.
    _loginTitleLabel.font
    = _passwordTitleLabel.font
    = _loginButton.titleLabel.font
    = [UIFont CMTRegularFontSizeM];
    
    _inputLoginId.font
    = _inputPassword.font
    = [UIFont CMTRegularFontSizeS];
    
    //content label
    _loginTitleLabel.text = @"ユーザーID";
    _passwordTitleLabel.text = @"パスワード";
    _inputLoginId.placeholder = @"メールアドレスを入力";
    _inputPassword.placeholder = @"";
    
    [_loginButton setTitle:@"サインイン" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor CMTButtonGrayColor];
    
    //title
    self.title = @"サインイン";
    
    //navibar.
    UIBarButtonItem *signup_button = [[UIBarButtonItem alloc] initWithTitle:@"新規登録"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(signUpButtonTouched:)];
    self.navigationItem.rightBarButtonItems = @[signup_button];
    
}

#pragma mark - private methods
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
    if (manager.currentCmtUser != nil) {
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
