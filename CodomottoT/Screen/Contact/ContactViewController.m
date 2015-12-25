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

@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)NSArray *textArray;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

- (void)initControls {
    
    //title
    self.title = @"連絡帳";
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
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
    }
    

#if 1
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.contactMainCell = [_mainTableView dequeueReusableCellWithIdentifier:@"ContactMainCell"]; // 追加
    
    // 追加
    // 文字列の配列の作成
    _textArray = @[
                   @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sodales diam sed turpis mattis dictum. In laoreet porta eleifend. Ut eu nibh sit amet est iaculis faucibus.",
                   @"initWithBitmapDataPlanes:pixelsWide:pixelsHigh:bitsPerSample:samplesPerPixel:hasAlpha:isPlanar:colorSpaceName:bitmapFormat:bytesPerRow:bitsPerPixel:",
                   @"祇辻飴葛蛸鯖鰯噌庖箸",
                   @"Nam in vehicula mi.",
                   @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
                   @"あのイーハトーヴォの\nすきとおった風、\n夏でも底に冷たさをもつ青いそら、\nうつくしい森で飾られたモーリオ市、\n郊外のぎらぎらひかる草の波。",
                   ];
#endif
    
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    // 追加
    // データ作成
    int dataIndex = arc4random() % _textArray.count;
    NSString *string = _textArray[dataIndex];
    NSDate *date = [NSDate date];
    NSDictionary *dataDictionary = @{@"string": string, @"date":date};
    
    // データ挿入
    [_objects insertObject:dataDictionary atIndex:0]; // 修正
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Action
- (void)requestUserButtonTouched:(id)sender {
    
    [StoryboardUtil openRequestUserViewController:self completion:nil];
    
}

#pragma mark - UITableView helper methods
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ContactMainCell *contactCell = (ContactMainCell *)cell;
    
    // メインラベルに文字列を設定
    NSDictionary *dataDictionary = _objects[indexPath.row];
    contactCell.contentLabel.text = dataDictionary[@"string"];
    
    // サブラベルに文字列を設定
    NSDate *date = dataDictionary[@"date"];
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
    return _objects.count;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
