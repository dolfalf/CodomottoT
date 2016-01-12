//
//  RegistSchoolViewController.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "CMTViewController.h"
@interface CMTZipCodeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *inputZipcode;
@property (nonatomic, weak) IBOutlet UIButton *zipSearchButton;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *kanaLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputExtraAddress;
@end

@interface RegistSchoolViewController : CMTViewController

@end
