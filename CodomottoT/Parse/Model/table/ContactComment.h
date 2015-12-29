//
//  ContactComment.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@class Contact;

@interface ContactComment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) Contact *postContact;     //relation contact.
@property (nonatomic, strong) User *postUser;           //relation contact.
@property (nonatomic, assign) BOOL deleteFlag;          //defaullt NO
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
