//
//  SignUpViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignUpViewController.h"
#import "CMTParseManager.h"

NSString* const kSignUpViewControllerNotificationSignUpSuccess = @"signUpViewControllerNotificationSignUpSuccess";
NSString* const kSignUpViewControllerNotificationSignUpFail = @"signUpViewControllerNotificationSignUpFail";

typedef NS_ENUM(NSInteger, SignupCellType) {
    SignupCellTypeUserType = 0,
    SignupCellTypeUserId,
    SignupCellTypePasswrod,
    SignupCellTypeOKButton,
    SignupCellTypeMaxCount,
};
const float kSignupCellHeight = 50.f;

@interface SignUpViewController () <UITextFieldDelegate>

@property (nonatomic, strong) CMTInputTextCell *userIdCell;
@property (nonatomic, strong) CMTInputTextCell *passwordCell;
@property (nonatomic, strong) CMTSegmentCell *userTypeCell;
@property (nonatomic, strong) CMTButtonCell *okButtonCell;
@end

@implementation SignUpViewController

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
    
    self.title = @"新規登録";
    
    UIBarButtonItem *cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[cancel_button];
    
}

- (void)signup {
    NSLog(@"%s, userId[%@], password[%@], userType[%ld]" , __FUNCTION__,
          _userIdCell.inputTextField.text,
          _passwordCell.inputTextField.text,
          (long)_userTypeCell.segmentControl.selectedSegmentIndex);
    
    //TODO: いろいろ設定する項目はあるが、とりあえず最小限の情報のみセット
    [[CMTParseManager sharedInstance] signInUserWithUserEmailAddress:_userIdCell.inputTextField.text
                                                        withPassword:_passwordCell.inputTextField.text
                                                        withUserType:_userTypeCell.segmentControl.selectedSegmentIndex
                                                      withCompletion:^(BOOL isSucceeded, NSError *resultError) {
                                                          
                                                          NSLog(@"isSucceeded[%@]", isSucceeded?@"YES":@"NO");
                                                          
                                                          if (isSucceeded) {
                                                              
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpViewControllerNotificationSignUpSuccess object:nil];
                                                              });
                                                              
                                                              //遷移処理
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }else {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpViewControllerNotificationSignUpFail object:nil];
                                                              });
                                                          }
                                                          
                                                      }];
    
}


#pragma mark - Action
- (void)cancelButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userTypeValueChanged:(id)sender {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSignupCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return SignupCellTypeMaxCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case SignupCellTypeUserType:
        {
            if (_userTypeCell == nil) {
                self.userTypeCell = [tableView dequeueReusableCellWithIdentifier:@"CMTSegmentCell" forIndexPath:indexPath];
                [_userTypeCell.segmentControl setTitle:@"Parents" forSegmentAtIndex:UserTypeParents];
                [_userTypeCell.segmentControl setTitle:@"Head Teacher" forSegmentAtIndex:UserTypeHeadTeacher];
                [_userTypeCell.segmentControl setTitle:@"Teacher" forSegmentAtIndex:UserTypeTeacher];
                _userTypeCell.segmentControl.selectedSegmentIndex = UserTypeParents;
                
                [_userTypeCell.segmentControl addTarget:self
                                                 action:@selector(userTypeValueChanged:)
                                       forControlEvents:UIControlEventValueChanged];
            }
            
            return _userTypeCell;
        }
            break;
        case SignupCellTypeUserId:
        {
            if (_userIdCell == nil) {
                self.userIdCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _userIdCell.inputTextField.delegate = self;
                _userIdCell.inputTextField.placeholder = @"Input UserId";
                _userIdCell.titleLabel.text = @"UserId";
                _userIdCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return _userIdCell;
            
        }
            break;
        case SignupCellTypePasswrod:
        {
            if (_passwordCell == nil) {
                self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _passwordCell.inputTextField.delegate = self;
                _passwordCell.inputTextField.placeholder = @"Input Password";
                _passwordCell.inputTextField.secureTextEntry = YES;
                _passwordCell.titleLabel.text = @"Password";
                _passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return _passwordCell;
        }
            break;
        case SignupCellTypeOKButton:
        {
            if (_okButtonCell == nil) {
                self.okButtonCell = [tableView dequeueReusableCellWithIdentifier:@"CMTButtonCell" forIndexPath:indexPath];
                _okButtonCell.buttonLabel.text = @"OK";
                _okButtonCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            
            return _okButtonCell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == SignupCellTypeOKButton) {
        //signIn
        [self signup];
    }
}


@end
