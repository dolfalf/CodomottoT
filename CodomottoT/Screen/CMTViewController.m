//
//  CMTViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/18.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "CMTViewController.h"

const float kCellDefaultHeight = 60.f;
#pragma mark - CMTTableCell
@implementation CMTTableCell

@end

#pragma mark CMTInputTextCell
@implementation CMTInputTextCell

@end

#pragma mark CMTButtonCell
@implementation CMTButtonCell

@end

#pragma mark CMTSegmentCell
@implementation CMTSegmentCell

@end

#pragma mark CMTCheckBoxCell
@interface CMTCheckBoxCell()
@property (nonatomic, assign) id tar;
@property (nonatomic, assign) SEL sel;

@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@end

@implementation CMTCheckBoxCell

- (void)addTarget:(id)target checkButtonTouched:(SEL)action {
    self.tar = target;
    self.sel = action;
}

- (void)setIsChecked:(BOOL)isChecked {

    _checkButton.backgroundColor = isChecked?[UIColor redColor]:[UIColor grayColor];
    
    _isChecked = isChecked;
}

- (IBAction)checkButtonTouched:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.isChecked = sender.selected;
    
    if (_tar != nil && [_tar respondsToSelector:_sel]) {
        [_tar performSelectorOnMainThread:_sel withObject:self waitUntilDone:NO];
    }
}

@end

#pragma mark - CMTViewController
@interface CMTViewController ()

@end

@implementation CMTViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#if 0
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
#endif
    
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

#pragma mark - TableView delegate metodhs
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellDefaultHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#if 0
    return 1;
#else
    return 0;
#endif
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMTTableCell" forIndexPath:indexPath];
#if 0
    cell.contentLabel.text = @"Samle Cell.";
#endif
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
