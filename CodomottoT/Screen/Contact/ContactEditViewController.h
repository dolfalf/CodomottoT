//
//  ContactEditViewController.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/28.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@interface ContactEditViewController : UIViewController

@property (nonatomic, assign) BOOL newPost;
@property (nonatomic, strong) Contact *contact;

@end
