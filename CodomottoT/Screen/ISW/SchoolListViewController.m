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
    self.title = @"School List";
    
    //toolbar.
    UIBarButtonItem *regist_button = [[UIBarButtonItem alloc] initWithTitle:@"Regist"
                                                                      style:UIBarButtonItemStyleDone target:self
                                                                     action:@selector(registButtonTouched:)];
    
    self.toolbarItems = @[regist_button];
    
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
- (void)registButtonTouched:(id)sender {
    
    [StoryboardUtil openRegistSchoolViewController:self completion:nil];
}

#pragma mark - TableView delegate metodhs
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _schools.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    School *school = _schools[indexPath.row];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", school.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    School *school = _schools[indexPath.row];
    
    if (mgr.loginUser.cmtUserType == UserTypeHeadTeacher) {
        //園長の場合
        [CMTParseManager sharedInstance].currentSchool = school;
        
        //遷移
        [self performSegueWithIdentifier:@"RequestUserListSegue" sender:self];
        
    }else {
        //Request Userへ登録しておく
        RequestUserModel *model = [RequestUserModel new];
        RequestUser *user = [RequestUser createModel];
        user.requestUser = mgr.loginUser;
        user.registSchool = school;
        
        [model save:user completion:^(BOOL succeeded, NSError *resultError) {
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                //許可待ち画面へ遷移
                [self performSegueWithIdentifier:@"AllowWaitSegue" sender:self];
            });
        }];
    }
}

@end
