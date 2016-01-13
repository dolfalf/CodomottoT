//
//  ContactEditViewController.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/28.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "ContactEditViewController.h"
#import "UITextView+Placeholder.h"
#import "RFKeyboardToolbar.h"
#import "QBImagePickerController.h"
#import "UIImage+Resize.h"
#import "DCCommentView.h"

#import "ContactModel.h"

#import "UIViewController+Alert.h"
#import "UIViewController+HUD.h"

@interface ContactEditViewController () <UITextViewDelegate, QBImagePickerControllerDelegate, DCCommentViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *postTextView;
@property (nonatomic, weak) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic, strong) RFKeyboardToolbar *keyboardToolbar;

@property (nonatomic, weak) IBOutlet UITableView *commentTableView;
@property (nonatomic, strong) DCCommentView *commentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, assign) BOOL showKeyboard;

@property (nonatomic, strong) NSMutableArray *postImages;
@end

@implementation ContactEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControls];
    
    [self addKeyboardNotification];
    
    _showKeyboard = NO;
    _postImages = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_contact) {
        _postTextView.text = _contact.content;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    
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
    
    self.title = @"投稿";
    
    _postTextView.placeholder = @"連絡帳を書いてください。";
    
    //前画面で設定される
    _postTextView.editable = _newPost;
    
    //右、完了
    UIBarButtonItem *right_button = [[UIBarButtonItem alloc] initWithTitle:@"完了"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(saveButtonTouched:)];
    
    self.navigationItem.rightBarButtonItems = @[right_button];
    
    //左、キーボド閉じる、戻る
    UIBarButtonItem *close_button = [[UIBarButtonItem alloc] initWithTitle:_newPost?@"キャンセル":@"戻る"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(closeButtonTouched:)];
    
    self.navigationItem.leftBarButtonItems = @[close_button];
    
    //keyboard toolbar.
    NSMutableArray *buttons = NSMutableArray.array;
    
    RFToolbarButton *button = [RFToolbarButton buttonWithTitle:@"写真" andEventHandler:^{
        [self openImagePickerController];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addObject:button];
    
    if (_newPost) {
        _keyboardToolbar = [RFKeyboardToolbar toolbarWithButtons:buttons];
        _postTextView.inputAccessoryView = _keyboardToolbar;
        _postTextView.delegate = self;
    }else {
        self.commentView = [[DCCommentView alloc] initWithScrollView:_commentTableView frame:self.view.bounds];
        self.commentView.delegate = self;
        [self.view addSubview:self.commentView];
        
        //self.commentView.charLimit = 255; you can set this if you want a character limit
        self.commentView.tintColor = [UIColor redColor]; //sets the proper accent items to red
        //self.commentView.accessoryImage = [UIImage imageNamed:@"someimage"]; where the camera button would go
        //more setup code
    }
    
}

- (void)addKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notification callback
- (void)keyboardWillShow:(NSNotification *)notification {

    self.showKeyboard = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.showKeyboard = NO;
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Action
- (void)saveButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    if ([_postTextView.text isEqualToString:@""]) {
        return;
    }
    
    [self showIndicator];
    
    ContactModel *contact_model = [ContactModel new];
    
    [contact_model postContact:_postTextView.text photoItems:_postImages block:^(BOOL success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideIndicator];
        });
        
        if (success) {
            [self showConfirmAlertView:@"投稿しました。" block:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        
    }];
}

- (void)closeButtonTouched:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    if (_showKeyboard) {
        [_postTextView resignFirstResponder];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)openImagePickerController {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 3;

    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    
    float photo_frame_size = 80.f;
    float margin = 4.f;
    
    int image_count = 0;
    
    __weak typeof(self) weakSelf = self;
    
    [_postImages removeAllObjects];
    
    _photoScrollView.contentSize = CGSizeMake(photo_frame_size * assets.count, _photoScrollView.frame.size.height);
    for (PHAsset* asset in assets) {
        
        [self updateImageViewWithAsset:asset
                                  size:CGSizeMake(asset.pixelWidth/2.f, asset.pixelHeight/2.f) block:^(UIImage *photoImage) {
                                      
                                      //photoImage
                                      [weakSelf.postImages addObject:photoImage];

                                      //thumbnail
                                      UIImage *resize_image = [UIImage resizedImage:photoImage
                                                                              width:photo_frame_size - margin
                                                                             height:photo_frame_size - margin];

                                      UIImageView *imageView = [[UIImageView alloc] initWithImage:resize_image];
                                      imageView.frame = CGRectMake(photo_frame_size * image_count,0,
                                                                   photo_frame_size - margin, photo_frame_size - margin);
                                      
                                      [weakSelf.photoScrollView addSubview:imageView];
                                      
                                  }];
        
        image_count++;
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - QBImagePickerController helper
- (void)updateImageViewWithAsset:(PHAsset *)asset size:(CGSize)size block:(void(^)(UIImage *))block {
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (result) {
                                                    
                                                    if (block) {
                                                        //UIImage.
                                                        block(result);
                                                    }
                                                }else {
                                                    if (block) {
                                                        block(nil);
                                                    }
                                                }
                                            }];
}

#pragma mark - DCCommentView delegate methods
-(void)didSendComment:(NSString*)text {
    NSLog(@"%s", __FUNCTION__);
    
}

@end
