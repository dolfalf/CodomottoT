//
//  ChildListViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/05.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "ChildListViewController.h"
#import "ChildModel.h"

@interface ChildListViewController()

@property (nonatomic, strong) NSArray *childs;
@property (nonatomic, strong) NSMutableArray *modifidChilds;

@end

@implementation ChildListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    //変更対象こどもリスト
    self.modifidChilds = [NSMutableArray new];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
    
    [self loadChildList];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
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
    
    if ([segue.identifier isEqualToString:@""]) {
        
    }
}

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"生徒選択";
    
    //navi button
    UIBarButtonItem *save_button = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(saveButtonTouched:)];
    
    self.navigationItem.rightBarButtonItems = @[save_button];
    
}

- (void)loadChildList {
    
}

#pragma mark - Action
- (void)saveButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
}
- (void)cellCheckButtonTouched:(id)sender {
    CMTCheckBoxCell *cell = sender;
    
//    cell.isChecked
}

#pragma mark - TableView delegate metodhs

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _childs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTCheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTCheckBoxCell" forIndexPath:indexPath];
    
    Child *child = _childs[indexPath.row];
    
    [cell addTarget:self checkButtonTouched:@selector(cellCheckButtonTouched:)];
    cell.obj = child;
    
    cell.titleLabel.text = child.name;
    cell.isChecked = child.cmtGroup==nil?NO:YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
