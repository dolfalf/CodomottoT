//
//  RegistSchoolViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "RegistSchoolViewController.h"
#import "SchoolModel.h"
#import "const.h"
#import "UIViewController+Alert.h"
#import "LPPopupListView.h"
#import "ZipSearch.h"

const float kRegistSchoolCellZipcodeHeight = 90.f;

@interface CMTZipCodeCell()

@end

@implementation CMTZipCodeCell

- (void)awakeFromNib {
    
    _inputZipcode.font
    = _addressLabel.font
    = _kanaLabel.font
    = [UIFont CMTRegularFontSizeS];
    
    _zipSearchButton.titleLabel.font = [UIFont CMTRegularFontSizeM];
    
    _inputZipcode.placeholder = @"数字のみ入力（'-'なし）";
    [_zipSearchButton setTitle:@"住所検索" forState:UIControlStateNormal];
    
    _zipSearchButton.layer.cornerRadius = 5;
    _zipSearchButton.clipsToBounds = YES;
    
}

@end

#pragma mark - RegistSchoolViewController
typedef NS_ENUM(NSInteger, RegistSchoolCellType) {
    RegistSchoolCellTypeName = 0,
    RegistSchoolCellTypeZipcode,
    RegistSchoolCellTypeDescription,
    RegistSchoolCellTypeOKButton,
    RegistSchoolCellTypeMaxCount,
};

const float kRegistSchoolCellHeight = 50.f;

@interface RegistSchoolViewController () <UITextFieldDelegate, LPPopupListViewDelegate>

@property (nonatomic, strong) CMTInputTextCell *nameCell;
@property (nonatomic, strong) CMTZipCodeCell *zipcodeCell;
@property (nonatomic, strong) CMTInputTextCell *descriptionCell;
@property (nonatomic, strong) CMTButtonCell *okButtonCell;

@property (nonatomic, strong) NSArray *zipcodeResults;
@end

@implementation RegistSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
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

#pragma mark - private methods
- (void)initControls {
    
    self.title = @"園登録";
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)registSchool {
    
    NSLog(@"%s, name[%@], desc[%@]" , __FUNCTION__,
          _nameCell.inputTextField.text,
          _descriptionCell.inputTextField.text);
    
    if ([_nameCell.inputTextField.text isEqualToString:@""]
        || [_descriptionCell.inputTextField.text  isEqualToString:@""]) {
        return;
    }
    
    //TODO: いろいろ設定する項目はあるが、とりあえず最小限の情報のみセット
    SchoolModel *school_model = [SchoolModel new];
    School *school = [School createModel];
    
    school.name = _nameCell.inputTextField.text;
    school.description = _descriptionCell.inputTextField.text;
    
    [school_model registSchool:school block:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = (error==nil)?@"園を登録しました。":error.description;
            
            [self showConfirmAlertView:message block:^{
                [StoryboardUtil pushStartContactViewController:self animated:YES completion:nil];
            }];
        });
        
    }];
}

#pragma mark - Action
- (void)OKButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    //regist school.
    [self registSchool];
}

- (void)zipSearchButtonTouched:(id)sender {

    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    
    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    
    
    //ZipCode取得
    __weak typeof(self) weafSelf = self;
    ZipSearch *zip_search = [ZipSearch new];
    [zip_search requestAddress:@"1150053" block:^(NSArray *results) {
//        NSLog(@"%@", results);
        
        weafSelf.zipcodeResults = results;
        NSMutableArray *address_name = [NSMutableArray new];
        
        for (ZipSearchResult *z_result in _zipcodeResults) {
            NSString *address_text = [NSString stringWithFormat:@"%@%@%@",
                                      z_result.address1,
                                      z_result.address2,
                                      z_result.address3];
            
            [address_name addObject:address_text];
        }
        
        LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"住所選択" list:address_name
                                                           selectedIndexes:nil
                                                                     point:point
                                                                      size:size
                                                         multipleSelection:YES
                                              disableBackgroundInteraction:YES];
        
        listView.multipleTouchEnabled = NO;
        listView.delegate = weafSelf;
        [listView showInView:weafSelf.navigationController.view animated:YES];
        
    }];
    
}

#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == RegistSchoolCellTypeZipcode) {
        return kRegistSchoolCellZipcodeHeight;
    }
    
    return kRegistSchoolCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return RegistSchoolCellTypeMaxCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case RegistSchoolCellTypeName:
        {
            if (_nameCell == nil) {
                self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _nameCell.inputTextField.delegate = self;
                _nameCell.inputTextField.placeholder = @"";
                _nameCell.titleLabel.text = @"園名";
            }
            
            return _nameCell;
        }
            break;
        case RegistSchoolCellTypeZipcode:
        {
            if (_zipcodeCell == nil) {
                self.zipcodeCell = [tableView dequeueReusableCellWithIdentifier:@"CMTZipCodeCell"
                                                                   forIndexPath:indexPath];
                _zipcodeCell.inputZipcode.delegate = self;
                [_zipcodeCell.zipSearchButton addTarget:self
                                                 action:@selector(zipSearchButtonTouched:)
                                       forControlEvents:UIControlEventTouchUpInside];
            }
            
            return _zipcodeCell;
        }
            break;
        case RegistSchoolCellTypeDescription:
        {
            if (_descriptionCell == nil) {
                self.descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _descriptionCell.inputTextField.delegate = self;
                _descriptionCell.inputTextField.placeholder = @"Input description";
                _descriptionCell.titleLabel.text = @"Decription";
            }
            
            return _descriptionCell;
            
        }
            break;
        case RegistSchoolCellTypeOKButton:
        {
            if (_okButtonCell == nil) {
                self.okButtonCell = [tableView dequeueReusableCellWithIdentifier:@"CMTButtonCell" forIndexPath:indexPath];
                _okButtonCell.buttonTitle = @"OK";
                [_okButtonCell addTarget:self OKButtonTouched:@selector(OKButtonTouched:)];
            }
            
            return _okButtonCell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - LPPopupListViewDelegate

- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index
{
    NSLog(@"popUpListView - didSelectIndex: %d", index);
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes
{
    NSLog(@"popupListViewDidHide - selectedIndexes: %@", selectedIndexes.description);
    
    
    NSMutableIndexSet *aaa = [[NSMutableIndexSet alloc] initWithIndexSet:selectedIndexes];
    
//    self.textView.text = @"";
    
    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        self.textView.text = [self.textView.text stringByAppendingFormat:@"%@\n", [[self list] objectAtIndex:idx]];
        
    }];
    
}
    
@end
