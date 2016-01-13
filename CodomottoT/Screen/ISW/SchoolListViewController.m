//
//  SchoolListViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "SchoolListViewController.h"
#import "CMTParseManager.h"
#import "SchoolModel.h"
#import "RequestUserModel.h"
#import "UIViewController+HUD.h"

const float kSchoolListCellHeight = 60.f;

@interface SchoolListViewController ()

@property (nonatomic, assign) BOOL hasSchoolData;
@property (nonatomic, strong) NSArray *schools;
@end

@implementation SchoolListViewController

#pragma mark - setter
- (void)setHasSchoolData:(BOOL)b {
    
    if (b) {
        self.mainTableView.hidden = NO;
        self.noDataLabel.hidden = YES;
    }else {
        self.mainTableView.hidden = YES;
        self.noDataLabel.hidden = NO;
    }
    
    _hasSchoolData = b;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadSchoolData];
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
    self.title = @"園選択";
    
    //navibar.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.hasSchoolData = YES;
}

- (void)loadSchoolData {
    
    SchoolModel *school_model = [SchoolModel new];
    
    [school_model fetchAll:^(NSArray *schools, NSError *resultError) {
        //
        self.schools = schools;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (schools != nil && schools.count > 0 ) {
                self.hasSchoolData = YES;
            }else {
                self.hasSchoolData = NO;
            }
            
            [self.mainTableView reloadData];
        });
    }];
}

#pragma mark - Action

#pragma mark - TableView delegate metodhs
#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kSchoolListCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _schools.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    cell.cellStyle = CMTTableCellStyle1;//CMTTableCellStyle2;
    
    School *school = _schools[indexPath.row];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", school.name];
    cell.descLabel.text = @"";
    //TODO:
    cell.descLabel.text = @"東京都千代田区";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    School *school = _schools[indexPath.row];
    
    if (mgr.userType == UserTypeHeadTeacher) {
        //園長は園選択画面は使わない
        return;
    }
    
    [self showIndicator];
    
    //User園選択情報保存、Request Userへ登録
    [mgr registRequestUser:school block:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideIndicator];
        });
        
        if (error == nil) {
            //許可待ち画面へ遷移
            [StoryboardUtil pushAllowWaitViewController:self animated:YES completion:nil];
        }
    }];
    
}

@end
