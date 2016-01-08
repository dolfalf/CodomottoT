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
#import "UIViewController+Alert.h"

@interface AllowWaitViewController ()

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
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
    _gotoButton.layer.cornerRadius = 5;
    _gotoButton.clipsToBounds = YES;
    
    //initialize controls
    _descriptionLabel.font
    = _gotoButton.titleLabel.font
    = [UIFont CMTRegularFontSizeM];
    
    //content label
    _descriptionLabel.text = @"園長が承認すると利用できるようになります。";
    [_gotoButton setTitle:@"参加する" forState:UIControlStateNormal];
    [_gotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _gotoButton.backgroundColor = [UIColor CMTButtonGrayColor];
    
    //toolbar.
    UIBarButtonItem *logout_button = [[UIBarButtonItem alloc] initWithTitle:@"ログアウト"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(logoutButtonTouched:)];
    
    self.toolbarItems = @[logout_button];
    
}

- (void)enabledMainButton {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _gotoButton.enabled = YES;
    });
}

#pragma mark - Action
- (void)logoutButtonTouched:(id)sender {

    //root画面へ遷移してログイン画面に戻る

    NSLog(@"%s", __FUNCTION__);
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    [mgr signOut:^{
        
        NSString *message = mgr.isLogin?@"ログアウトを失敗しました。":@"ログアウトしました。";
        [self showConfirmAlertView:message
                             block:^{
                                 [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
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
