//
//  SignUpViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignUpViewController.h"

typedef NS_ENUM(NSInteger, SignupCellType) {
    SignupCellTypeUserId = 0,
    SignupCellTypePasswrod,
    SignupCellTypeOKButton,
    SignupCellTypeMaxCount,
};
const float kSignupCellHeight = 50.f;

@interface SignUpViewController () <UITextFieldDelegate>

@property (nonatomic, strong) CMTInputTextCell *userIdCell;
@property (nonatomic, strong) CMTInputTextCell *passwordCell;

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
    
    self.title = @"Sign Up";
    
    UIBarButtonItem *cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[cancel_button];
    
}

- (void)signup {
    NSLog(@"%s, userId[%@], password[%@]", __FUNCTION__,
          _userIdCell.inputTextField.text,
          _passwordCell.inputTextField.text);
    
    //TODO: 
}

#pragma mark - Action
- (void)cancelButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
        case SignupCellTypeUserId:
        {
            self.userIdCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
            _userIdCell.inputTextField.delegate = self;
            _userIdCell.inputTextField.placeholder = @"Input UserId";
            _userIdCell.titleLabel.text = @"UserId";
            _userIdCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return _userIdCell;
            
        }
            break;
        case SignupCellTypePasswrod:
        {
            self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
            _passwordCell.inputTextField.delegate = self;
            _passwordCell.inputTextField.placeholder = @"Input Password";
            _passwordCell.inputTextField.secureTextEntry = YES;
            _passwordCell.titleLabel.text = @"Password";
            _passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return _passwordCell;
        }
            break;
        case SignupCellTypeOKButton:
        {
            CMTButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTButtonCell" forIndexPath:indexPath];
            cell.buttonLabel.text = @"OK";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            return cell;
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
