//
//  ContactViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "ContactViewController.h"
#import "CMTParseManager.h"
#import "StoryboardUtil.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
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

- (void)initControls {
    
    //title
    self.title = @"連絡帳";
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    //toolbar.
#if 0
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
#endif
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    if (mgr.userType == UserTypeHeadTeacher) {
        //園長の場合、リクエストユーザー見る画面へ
        UIBarButtonItem *request_user_button = [[UIBarButtonItem alloc] initWithTitle:@"リクエスト一覧"
                                                                                style:UIBarButtonItemStyleDone target:self
                                                                               action:@selector(requestUserButtonTouched:)];
        
        self.toolbarItems = @[request_user_button];
    }
}

#pragma mark - Action
- (void)requestUserButtonTouched:(id)sender {
    
    [StoryboardUtil openRequestUserViewController:self completion:nil];
    
}

@end
