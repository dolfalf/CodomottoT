//
//  GroupEditViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/04.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "GroupEditViewController.h"
#import "GroupModel.h"
#import "CMTParseManager.h"

typedef NS_ENUM(NSInteger, GroupEditCellType) {
    GroupEditCellTypeName = 0,
    GroupEditCellTypeMax,
};

@interface GroupEditViewController() <UITextFieldDelegate>

@property (nonatomic, strong) CMTInputTextCell *nameCell;

@end

@implementation GroupEditViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@""]) {
        //
    }
}
*/

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = (_editType==GroupEditTypeNew)?@"クラス生成":@"クラス変更";
    
    //navi button
    UIBarButtonItem *cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[cancel_button];
    
    UIBarButtonItem *save_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                 target:self
                                                                                 action:@selector(saveButtonTouched:)];
    
    self.navigationItem.rightBarButtonItems = @[save_button];
}

- (void)closeViewController {
    
    if (_editType == GroupEditTypeNew) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Action
- (void)cancelButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self closeViewController];
    
}

- (void)saveButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    if (_nameCell == nil
        || [_nameCell.inputTextField.text isEqualToString:@""]) {
        return;
    }
    
    GroupModel *group_model = [GroupModel new];
    
    Group *save_group = nil;
    
    if (_editType == GroupEditTypeNew) {
        //新規
        save_group = [Group createModel];
        save_group.cmtSchool = [CMTParseManager sharedInstance].currentSchool;
        save_group.name = _nameCell.inputTextField.text;
    }else {
        //変更
        save_group = _group;
        save_group.name = _nameCell.inputTextField.text;
    }
    
    //保存
    [group_model save:save_group block:^(NSError *error) {
        
        if (error == nil) {
            [self closeViewController];
        }
        
    }];
    
}

#pragma mark - TableView delegate metodhs
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case GroupEditCellTypeName:
        {
            if (_nameCell == nil) {
                self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _nameCell.inputTextField.delegate = self;
                _nameCell.inputTextField.placeholder = @"Input group name.";
                _nameCell.titleLabel.text = @"Group Name";
                _nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                //初期値設定
                if (_editType == GroupEditTypeModify) {
                    _nameCell.inputTextField.text = _group.name;
                }
            }
            
            return _nameCell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
