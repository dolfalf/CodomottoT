//
//  AllowWaitViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/24.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "AllowWaitViewController.h"
#import "StoryboardUtil.h"
#import "CMTParseManager.h"
#import "SIAlertView.h"

@interface AllowWaitViewController ()

@property (nonatomic, weak) IBOutlet UIButton *gotoButton;
@property (nonatomic) NSTimer *timer;
@end

@implementation AllowWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //timer起動（許可をチェックする
    //許可されたらボタンを活性化する
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self killTimer];
    
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

#pragma mark - private methods
- (void)initControls {
    
    self.title = @"承認待ち";
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    _gotoButton.enabled = NO;
    
    //toolbar.
    UIBarButtonItem *logout_button = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(logoutButtonTouched:)];
    
    self.toolbarItems = @[logout_button];
    
    
    
}

- (void)enabledMainButton {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _gotoButton.enabled = YES;
    });
}

- (void)showAlertMessage:(NSString *)message {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:message];
    
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                              
                              [self.navigationController popToRootViewControllerAnimated:YES];
                          }];
    
}
#pragma mark - Action
- (void)logoutButtonTouched:(id)sender {

    //root画面へ遷移してログイン画面に戻る

    NSLog(@"%s", __FUNCTION__);
    
    [[CMTParseManager sharedInstance] logoutCurrentUserWithCompletion:^(BOOL isSucceeded, NSError *resultError) {
        if (isSucceeded) {
            NSLog(@"logout success");
            [self showAlertMessage:@"logout success"];
        }else {
            NSLog(@"logout failed.");
            [self showAlertMessage:@"logout failed"];
        }
    }];
    
}

- (IBAction)gotoMainButtonTouched:(id)sender {
    
    //contact画面へ遷移
    [StoryboardUtil openContactViewController:self  completion:nil];
    
}

#pragma mark - Timer
- (void)startTimer {
    
    _timer = [NSTimer timerWithTimeInterval:5.f
                                     target:self
                                   selector:@selector(onCheckAllowed:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)killTimer {
    
    // stop animation and release
    [self.timer invalidate];
    self.timer = nil;
    
}

- (void)onCheckAllowed:(NSTimer *)timer {

    NSLog(@"%s", __FUNCTION__);
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    BOOL hasAccess = [mgr hasAccessRoleToSchool];
    if (hasAccess == YES) {
        [self enabledMainButton];
    }
}

@end
