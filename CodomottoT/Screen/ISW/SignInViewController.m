//
//  SignInViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (nonatomic, strong) NSArray *users;
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
    
    [self.mainTableView reloadData];
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
    
    self.toolbarItems = @[signup_button];
}

#pragma mark - private methods
- (void)loadUserData {
    
    self.users = nil;
}

#pragma mark - Action
- (void)signUpButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
}

#pragma mark - TableView delegate metodhs
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _users.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    cell.contentLabel.text = @"Samle Cell.";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
