//
//  SignInViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignInViewController.h"
#import "CMTParseManager.h"

@interface SignInViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *inputLoginId;
@property (nonatomic, weak) IBOutlet UITextField *inputPassword;

@property (nonatomic, assign) BOOL isUserData;
@property (nonatomic, strong) NSArray *users;
@end

@implementation SignInViewController

#pragma mark - setter
- (void)setIsUserData:(BOOL)b {
    
    if (b) {
        self.mainTableView.hidden = NO;
        self.noDataLabel.hidden = YES;
    }else {
        self.mainTableView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    _isUserData = b;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    CMTParseManager *manager = [CMTParseManager sharedInstance];
    NSLog(@"%s, loginUser[%@]", __FUNCTION__, manager.loginUser);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadUserData];
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
    
    //toolbar.
    UIBarButtonItem *signup_button = [[UIBarButtonItem alloc] initWithTitle:@"SignUp"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(signUpButtonTouched:)];
    
    UIBarButtonItem *logout_button = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(logoutButtonTouched:)];
    
    self.toolbarItems = @[signup_button, logout_button];
    
    self.isUserData = YES;
}

#pragma mark - private methods
- (void)loadUserData {
    
    [[CMTParseManager sharedInstance] fetchUsers:UserTypeNone withCompletion:^(NSArray *users, NSError *resultError) {
        if (resultError == nil) {
            //success
            self.users = users;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
            });
        }
    }];
    
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
        }else {
            NSLog(@"logout failed.");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
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
                                                     }
                                                     
                                                   }];
    
}

#pragma mark - TableView delegate metodhs
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    User *current_user = [CMTParseManager sharedInstance].loginUser;
    
    if (current_user == nil) {
        return @"Not logined.";
    }

    return [NSString stringWithFormat:@"current user [%@]", current_user.username];
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
