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
#import "UIViewController+HUD.h"

const float kRegistSchoolCellZipcodeHeight = 120.f;

@interface CMTZipCodeCell()

@end

@implementation CMTZipCodeCell

- (void)awakeFromNib {
    
    _inputZipcode.font
    = _addressLabel.font
    = _kanaLabel.font
    = _inputExtraAddress.font
    = [UIFont CMTRegularFontSizeS];
    
    _addressLabel.text
    = _kanaLabel.text
    = @"";
    
    _zipSearchButton.titleLabel.font = [UIFont CMTRegularFontSizeM];
    
    _inputZipcode.placeholder = @"数字のみ入力（'-'なし）";
    [_zipSearchButton setTitle:@"住所検索" forState:UIControlStateNormal];
    [_zipSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _zipSearchButton.layer.cornerRadius = 5;
    _zipSearchButton.clipsToBounds = YES;
    
    _inputExtraAddress.placeholder = @"その他住所、建物名など";
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
@property (nonatomic, assign) NSInteger selectedZipcodeResultIndex;
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
    
    if (_zipcodeResults[_selectedZipcodeResultIndex] == nil) {
        return;
    }
    
    SchoolModel *school_model = [SchoolModel new];
    School *school = [School createModel];
    
    school.name = _nameCell.inputTextField.text;
    
    ZipSearchResult *zip_search_address = _zipcodeResults[_selectedZipcodeResultIndex];
    
    school.zipcode = zip_search_address.zipcode;
    school.address1 = zip_search_address.address1;
    school.address2 = zip_search_address.address2;
    school.address3 = zip_search_address.address3;
    school.kana1 = zip_search_address.kana1;
    school.kana2 = zip_search_address.kana2;
    school.kana3 = zip_search_address.kana3;
    school.prefcode = zip_search_address.prefcode;
    
    school.description = _descriptionCell.inputTextField.text;
    
    //HUD
    [self showIndicator];
    
    [school_model registSchool:school block:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //HUD
            [self hideIndicator];
            
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
    if ([_zipcodeCell.inputZipcode.text isEqualToString:@""]
        || _zipcodeCell.inputZipcode.text.length != 7) {
        //入力チェック
        return;
    }
    
    __weak typeof(self) weafSelf = self;
    ZipSearch *zip_search = [ZipSearch new];
    [zip_search requestAddress:_zipcodeCell.inputZipcode.text block:^(NSArray *results) {
//        NSLog(@"%@", results);
        
        weafSelf.zipcodeResults = results;
        
        if (results == nil || results.count == 0) {
            //No data.
            return;
        }
        
//        if (results.count == 1) {
//            //１つの場合はPopupはいらない
//            return;
//        }
        
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
                                                         multipleSelection:NO
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
    
    self.selectedZipcodeResultIndex = index;
    ZipSearchResult *zip_search_address = _zipcodeResults[_selectedZipcodeResultIndex];
    _zipcodeCell.addressLabel.text = [zip_search_address addressString];
    _zipcodeCell.kanaLabel.text = [zip_search_address kanaString];
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedIndexes:(NSIndexSet *)selectedIndexes
{
    NSLog(@"popupListViewDidHide - selectedIndexes: %@", selectedIndexes.description);
}
    
@end
