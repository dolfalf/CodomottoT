//
//  GroupDetailViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/04.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "Group.h"

#import "GroupEditViewController.h"

typedef NS_ENUM(NSInteger, GroupDetailCellType) {
    GroupDetailCellTypeName = 0,
    GroupDetailCellTypeTeacherList,
    GroupDetailCellTypeChildList,
    GroupDetailCellTypeMax,
};

@interface GroupDetailViewController()

@end

@implementation GroupDetailViewController

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
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
    
    if ([segue.identifier isEqualToString:@"GroupNameSegue"]) {
        
        GroupEditViewController *edit_con = (GroupEditViewController *)segue.destinationViewController;
        edit_con.editType = GroupEditTypeModify;
        edit_con.group = _group;
        
    } else if ([segue.identifier isEqualToString:@"GroupTeacherSegue"]) {
        //
    } else if ([segue.identifier isEqualToString:@"GroupChildSegue"]) {
        //
    }
}

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"クラス編集";
}

#pragma mark - Action

#pragma mark - TableView delegate metodhs
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return GroupDetailCellTypeMax;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case GroupDetailCellTypeName:
        {
            cell.contentLabel.text = _group.name ;
        }
            break;
        case GroupDetailCellTypeTeacherList:
        {
            cell.contentLabel.text = @"先生設定";
        }
            break;
        case GroupDetailCellTypeChildList:
        {
            cell.contentLabel.text = @"生徒設定";
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == GroupDetailCellTypeName) {
        [self performSegueWithIdentifier:@"GroupNameSegue" sender:self];
        
    }else if (indexPath.row == GroupDetailCellTypeTeacherList) {
        [self performSegueWithIdentifier:@"GroupTeacherSegue" sender:self];
        
    }else if(indexPath.row == GroupDetailCellTypeChildList) {
        [self performSegueWithIdentifier:@"GroupChildSegue" sender:self];
        
    }
    
}

@end