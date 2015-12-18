//
//  CMTViewController.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CMTTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end

@interface CMTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *mainTableView;

@end
