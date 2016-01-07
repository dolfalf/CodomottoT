//
//  UserListViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "UserListViewController.h"
#import "CMTParseManager.h"

@interface UserListViewController ()

@property (nonatomic, assign) BOOL hasUserData;
@property (nonatomic, strong) NSArray *users;
@end

@implementation UserListViewController

#pragma mark - setter
- (void)setHasUserData:(BOOL)b {
    
    if (b) {
        self.mainTableView.hidden = NO;
        self.noDataLabel.hidden = YES;
    }else {
        self.mainTableView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    _hasUserData = b;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    CMTParseManager *manager = [CMTParseManager sharedInstance];
    NSLog(@"%s, loginUser[%@]", __FUNCTION__, manager.currentCmtUser);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadUserData];
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
    self.title = @"ユーザー一覧";
    
    UIBarButtonItem *cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[cancel_button];
    
    self.hasUserData = YES;
}

- (void)loadUserData {
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    [mgr fetchUsers:UserTypeNone block:^(NSArray *users, NSError *error) {
        if (error == nil) {
            //success
            self.users = users;
            
            if (_users != nil && _users.count > 0) {
                self.hasUserData = YES;
            }else {
                self.hasUserData = NO;
            }
            
            [self.mainTableView reloadData];
        }
    }];
    
}

#pragma mark - Action
- (void)cancelButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - TableView delegate metodhs
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    User *current_user = [CMTParseManager sharedInstance].currentCmtUser;
    
    if (current_user == nil) {
        return @"Not login.";
    }
    
    return [NSString stringWithFormat:@"login user [%@]", current_user.username];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    User *user = _users[indexPath.row];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@ - %d", user.username, [user.cmtUserType intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
