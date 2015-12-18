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

@interface CMTTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end

@interface CMTInputTextCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputTextField;
@end

@interface CMTButtonCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *buttonLabel;
@end

@interface CMTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, weak) IBOutlet UILabel *noDataLabel;

@end
