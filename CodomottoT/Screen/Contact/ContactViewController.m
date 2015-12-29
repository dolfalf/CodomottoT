//
//  ContactViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "ContactViewController.h"
#import "CMTParseManager.h"
#import "StoryboardUtil.h"

#import "ContactModel.h"

#import "ContactEditViewController.h"

@implementation ContactMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@interface ContactViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) ContactMainCell *contactMainCell;

@property (nonatomic, strong) NSArray *contacts;
@end

@implementation ContactViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //
    __weak ContactViewController *weakSelf = self;
    
    ContactModel *contact_model = [ContactModel new];
    [contact_model fetchContacts:0 block:^(NSArray *items, NSError *error) {
        
        if (error == nil) {
            weakSelf.contacts = items;
            [weakSelf.mainTableView reloadData];
        }
        
    }];
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
    
    if ([segue.identifier isEqualToString:@"ContactEditSegue"]) {
        
        ContactEditViewController *dest_con = (ContactEditViewController *)segue.destinationViewController;
        
        if (sender == nil) {
            //新規投稿
            dest_con.editable = YES;
        }else {
            //連絡帳選択
            dest_con.editable = NO;
            dest_con.contact = sender;
        }
    }
}

#pragma mark - private methods
- (void)initControls {
    
    //title
    self.title = @"連絡帳";
    [self.navigationItem setHidesBackButton:YES animated:NO];
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    
    self.contactMainCell = [_mainTableView dequeueReusableCellWithIdentifier:@"ContactMainCell"]; // 追加
    
    //toolbar.
    
#if 0
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil];
#endif
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    if (mgr.userType == UserTypeHeadTeacher) {
        //園長の場合、リクエストユーザー見る画面へ
        UIBarButtonItem *request_user_button = [[UIBarButtonItem alloc] initWithTitle:@"リクエスト一覧"
                                                                                style:UIBarButtonItemStyleDone target:self
                                                                               action:@selector(requestUserButtonTouched:)];
        self.toolbarItems = @[request_user_button];
    }else {
        UIBarButtonItem *post_button = [[UIBarButtonItem alloc] initWithTitle:@"投稿"
                                                                        style:UIBarButtonItemStyleDone target:self
                                                                       action:@selector(postButtonTouched:)];
        self.toolbarItems = @[post_button];
    }
    
}

#pragma mark - Action
- (void)requestUserButtonTouched:(id)sender {
    
    [StoryboardUtil openRequestUserViewController:self completion:nil];
    
}

- (void)postButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"ContactEditSegue" sender:nil];
}

#pragma mark - UITableView helper methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ContactMainCell *contactCell = (ContactMainCell *)cell;
    
    // メインラベルに文字列を設定
    Contact *contact = _contacts[indexPath.row];
    
    contactCell.contentLabel.text = contact.content;
    
    // サブラベルに文字列を設定
    NSDate *date = contact.updatedAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日 HH時mm分ss秒";
    contactCell.nameLabel.text = [dateFormatter stringFromDate:date];
}

#pragma mark - UITableView delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 計測用のプロパティ"_stubCell"を使って高さを計算する
    [self configureCell:_contactMainCell atIndexPath:indexPath];
    [_contactMainCell layoutSubviews];
    CGFloat height = [_contactMainCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height + 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactMainCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];  // 追加
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Contact *contact = _contacts[indexPath.row];
    
    [self performSegueWithIdentifier:@"ContactEditSegue" sender:contact];
}

#if 0
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_contacts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#endif

@end
