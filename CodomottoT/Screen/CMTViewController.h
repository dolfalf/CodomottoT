//
//  CMTViewController.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "StoryboardUtil.h"

typedef NS_ENUM(NSInteger, CMTTableCellStyle ) {
    CMTTableCellStyle1, //title
    CMTTableCellStyle2, //title, desc
};

@interface CMTTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *descLabel;

@property (nonatomic, assign) CMTTableCellStyle cellStyle;  //default style1
@end

@interface CMTInputTextCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputTextField;
@end

@interface CMTButtonCell : UITableViewCell

@property (nonatomic, strong) NSString *buttonTitle;

- (void)addTarget:(id)target OKButtonTouched:(SEL)action;
@end

@interface CMTSegmentCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *descLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;
@end

@interface CMTCheckBoxCell : UITableViewCell

@property (nonatomic, strong) id obj;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL isChecked;

- (void)addTarget:(id)target checkButtonTouched:(SEL)action;
@end

@interface CMTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) IBOutlet UILabel *noDataLabel;

@end
