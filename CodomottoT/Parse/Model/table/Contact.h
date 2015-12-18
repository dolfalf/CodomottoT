//
//  Contact.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class User;

@interface Contact : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) User *postUser;
@property (nonatomic, strong) PFRelation *photos;
@property (nonatomic, strong) PFRelation *contactRead;
@property (nonatomic, strong) PFRelation *comments;

@property (nonatomic, assign) BOOL noticeFlag;          //default NO.
@property (nonatomic, assign) BOOL deleteFlag;          //default NO.
@property (nonatomic, strong) PFACL *ACL;               //set Role.

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
