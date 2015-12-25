//
//  SchoolMemberListViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/22.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "RequestUserListViewController.h"
#import "RequestUserModel.h"
#import "CMTParseManager.h"

@interface RequestUserListViewController ()

@property (nonatomic, assign) BOOL hasMemberData;
@property (nonatomic, strong) NSArray *members;
@end

@implementation RequestUserListViewController


#pragma mark - setter
- (void)setHasMemberData:(BOOL)b {
    
    if (b) {
        self.mainTableView.hidden = NO;
        self.noDataLabel.hidden = YES;
    }else {
        self.mainTableView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    
    _hasMemberData = b;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadMemberData];
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

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"承認待ちユーザーリスト";
    
    //toolbar.
    UIBarButtonItem *close_button = [[UIBarButtonItem alloc] initWithTitle:@"閉じる"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(closeButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[close_button];
    
    self.hasMemberData = YES;
}

- (void)loadMemberData {
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    RequestUserModel *request_user_model = [RequestUserModel new];
    
    [request_user_model fetchBySchool:mgr.currentSchool completion:^(NSArray *requestUsers, NSError *resultError) {
        //
        self.members = requestUsers;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestUsers != nil && requestUsers.count > 0 ) {
                self.hasMemberData = YES;
            }else {
                self.hasMemberData = NO;
            }
            
            [self.mainTableView reloadData];
        });
    }];
}

#pragma mark - Action
- (void)closeButtonTouched:(id)sender {
    //Contact画面へ遷移
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView delegate metodhs
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _members.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    RequestUser *requesst_user = _members[indexPath.row];
    User *usr = (User *)requesst_user.requestUser;
    
//    cell.contentLabel.text = [NSString stringWithFormat:@"%@, %@", usr.objectId, usr.cmtUserType];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@", usr.objectId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RequestUser *request_user = _members[indexPath.row];
    
    //園長ではないときは許可できない。
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    if (mgr.userType != UserTypeHeadTeacher) {
        NSLog(@"No Auth role.");
        return;
    }
    
    //ロールリストにユーザー追加
    [mgr addUserSchoolRoleInBackground:request_user block:nil];
    
    //リクエストユーザーにフラグを立てる
    RequestUserModel *model = [RequestUserModel new];
    [model approvedInBackground:request_user];
    
    
    [self.mainTableView reloadData];
}

@end

