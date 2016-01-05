//
//  GroupListViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/30.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupModel.h"

#import "GroupDetailViewController.h"
#import "GroupEditViewController.h"

@interface GroupListViewController()

@property (nonatomic, strong) NSMutableArray *editItems;
@property (nonatomic, strong) NSArray *groups;
@end

@implementation GroupListViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    self.editItems = [NSMutableArray new];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
    
    [self loadGroupList];
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
    
    if ([segue.identifier isEqualToString:@"GroupDetailSegue"]) {
        //
        GroupDetailViewController *detail_con = (GroupDetailViewController *)segue.destinationViewController;
        detail_con.group = sender;
    }else if ([segue.identifier isEqualToString:@"GroupEditSegue"]) {
        GroupEditViewController *edit_con = (GroupEditViewController *)segue.destinationViewController;
        edit_con.editType = GroupEditTypeNew;
    }
}

#pragma mark - private method
- (void)initControls {
    
    //title
    self.title = @"クラス設定";
    
    //navi button
    UIBarButtonItem *edit_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                  target:self
                                                                                  action:@selector(editButtonTouched:)];
    
    self.navigationItem.rightBarButtonItems = @[edit_button];
    
    //toolbar button
    UIBarButtonItem *add_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addButtonTouched:)];
    self.toolbarItems = @[add_button];
}

- (void)loadGroupList {

    GroupModel *group_model = [GroupModel new];
    
    __weak GroupListViewController *weakSelf = self;
    [group_model fetchAll:^(NSArray *objects, NSError *err) {
        //
        if (err) {
            NSLog(@"%@", err.description);
        }else
        {
            weakSelf.groups = objects;
            
            [weakSelf.editItems removeAllObjects];
            [weakSelf.editItems addObjectsFromArray:objects];
        }
        
        [weakSelf.mainTableView reloadData];
        
    }];
}

#pragma mark - Action
- (void)editButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self setEditing:YES animated:YES];
}

- (void)addButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self performSegueWithIdentifier:@"GroupEditSegue" sender:self];
}

- (void)closeButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self setEditing:NO animated:YES];
    
}

#pragma mark - TableView helper
// 行の挿入
- (void)insertNewObject:(Group *)group
{
    if (!_editItems) {
        _editItems = [[NSMutableArray alloc] init];
    }
    [_editItems insertObject:group.name atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mainTableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableView delegate metodhs
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        //navi button
        UIBarButtonItem *close_button = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(closeButtonTouched:)];
        
        self.navigationItem.leftBarButtonItems = @[close_button];
    }else {
        self.navigationItem.leftBarButtonItems = nil;
    }
    
    [self.mainTableView setEditing:editing animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _editItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
    
    Group *group = _editItems[indexPath.row];
    
    cell.contentLabel.text = group.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Group *group = _groups[indexPath.row];
    
    [self performSegueWithIdentifier:@"GroupDetailSegue" sender:group];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// セルを削除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupModel *group_model = [GroupModel new];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Group *group = (Group *)[_editItems objectAtIndex:indexPath.row];
        __weak GroupListViewController *weakSelf = self;
        
        // Delete時の処理をここに書く
        [group_model remove:group block:^(NSError *error) {
            [weakSelf.editItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Insert時の処理をここに書く
        
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
