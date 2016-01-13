//
//  SettingViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/30.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SettingViewController.h"
#import "CMTParseManager.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SettingViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"設定";
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    if (mgr.userType == UserTypeHeadTeacher) {
        //head teacher menu
        
        self.menuItems = @[@{@"title":@"クラス設定",@"segue":@"GroupListSegue"},
                           @{@"title":@"リクエストユーザー承認",@"segue":@"RequestUserListSegue"}];
        
    }else if(mgr.userType == UserTypeTeacher) {
        //teacher menu
        self.menuItems = nil;
        
    }else if(mgr.userType == UserTypeParents) {
        //parents menu
        self.menuItems = @[@{@"title":@"お子様編集",@"segue":@"ChildEditListSegue"}];
    }
    
    //navi button
    UIBarButtonItem *close_button = [[UIBarButtonItem alloc] initWithTitle:@"閉じる"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(closeButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[close_button];
}

#pragma mark - Action
- (void)closeButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - TableView delegate metodhs
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _menuItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    NSDictionary *menuDict = _menuItems[indexPath.row];
    
    cell.contentLabel.text = menuDict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *menuDict = _menuItems[indexPath.row];
    
    [self performSegueWithIdentifier:menuDict[@"segue"] sender:self];
}

@end
