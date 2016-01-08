//
//  SignUpViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignUpViewController.h"
#import "CMTParseManager.h"
#import "UIViewController+Alert.h"

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
    [[CMTParseManager sharedInstance] signUp:_userIdCell.inputTextField.text
                                    password:_passwordCell.inputTextField.text
                                    userType:_userTypeCell.segmentControl.selectedSegmentIndex
                                       block:^(NSError *error) {
                                                          
                                           NSLog(@"success[%@]", error==nil?@"YES":@"NO");
                                          if (error==nil) {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpViewControllerNotificationSignUpSuccess
                                                                                                  object:nil];
                                              
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }else {
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kSignUpViewControllerNotificationSignUpFail
                                                                                                  object:nil];
                                              
                                              [self showConfirmAlertView:@"アカウント生成に失敗しました。" block:nil];
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

- (void)OKButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    //signIn
    [self signup];
}

#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == SignupCellTypeUserType) {
        return 70.f;
    }
    
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
                
                _userTypeCell.descLabel.text = @"登録するユーザータイプを選択します。";
                [_userTypeCell.segmentControl setTitle:@"保護者" forSegmentAtIndex:UserTypeParents];
                [_userTypeCell.segmentControl setTitle:@"園長" forSegmentAtIndex:UserTypeHeadTeacher];
                [_userTypeCell.segmentControl setTitle:@"先生" forSegmentAtIndex:UserTypeTeacher];
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
                _userIdCell.inputTextField.placeholder = @"メールアドレスを入力";
                _userIdCell.titleLabel.text = @"ユーザーID";
            }
            
            return _userIdCell;
            
        }
            break;
        case SignupCellTypePasswrod:
        {
            if (_passwordCell == nil) {
                self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _passwordCell.inputTextField.delegate = self;
                _passwordCell.inputTextField.placeholder = @"";
                _passwordCell.inputTextField.secureTextEntry = YES;
                _passwordCell.titleLabel.text = @"パスワード";
            }
            
            return _passwordCell;
        }
            break;
        case SignupCellTypeOKButton:
        {
            if (_okButtonCell == nil) {
                self.okButtonCell = [tableView dequeueReusableCellWithIdentifier:@"CMTButtonCell" forIndexPath:indexPath];
                _okButtonCell.buttonTitle = @"登録";
                [_okButtonCell addTarget:self OKButtonTouched:@selector(OKButtonTouched:)];
            }
            
            return _okButtonCell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
