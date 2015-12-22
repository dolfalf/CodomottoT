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
#import "SIAlertView.h"

typedef NS_ENUM(NSInteger, RegistSchoolCellType) {
    RegistSchoolCellTypeName = 0,
    RegistSchoolCellTypeDescription,
    RegistSchoolCellTypeOKButton,
    RegistSchoolCellTypeMaxCount,
};

const float kRegistSchoolCellHeight = 50.f;

@interface RegistSchoolViewController () <UITextFieldDelegate>

@property (nonatomic, strong) CMTInputTextCell *nameCell;
@property (nonatomic, strong) CMTInputTextCell *descriptionCell;
@property (nonatomic, strong) CMTButtonCell *okButtonCell;
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
    
    self.title = @"Regist School";
    
    UIBarButtonItem *cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[cancel_button];
    
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
    
    [school_model registSchool:school completion:^(BOOL succeeded, NSError *resultError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {
                [self showAlertMessage:@"School resgited."];
            }else {
                [self showAlertMessage:resultError.description];
            }
        });
        
    }];
}

- (void)showAlertMessage:(NSString *)message {
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:message];
    
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button1 Clicked");
                              [self dismissViewControllerAnimated:YES completion:nil];
                          }];
 
    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };
    
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    [alertView show];
}


#pragma mark - Action
- (void)cancelButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)userTypeValueChanged:(id)sender {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
                _nameCell.inputTextField.placeholder = @"Input name";
                _nameCell.titleLabel.text = @"Name";
                _nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return _nameCell;
        }
            break;
        case RegistSchoolCellTypeDescription:
        {
            if (_descriptionCell == nil) {
                self.descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"CMTInputTextCell" forIndexPath:indexPath];
                _descriptionCell.inputTextField.delegate = self;
                _descriptionCell.inputTextField.placeholder = @"Input description";
                _descriptionCell.titleLabel.text = @"Decription";
                _descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return _descriptionCell;
            
        }
            break;
        case RegistSchoolCellTypeOKButton:
        {
            if (_okButtonCell == nil) {
                self.okButtonCell = [tableView dequeueReusableCellWithIdentifier:@"CMTButtonCell" forIndexPath:indexPath];
                _okButtonCell.buttonLabel.text = @"OK";
                _okButtonCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            
            return _okButtonCell;
        }
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == RegistSchoolCellTypeOKButton) {
        //signIn
        [self registSchool];
    }
}

@end
