//
//  ContactRead.h
//  Codomotto
//
//  Created by kjcode on 2015/07/27.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class Contact;

@interface ContactRead : PFObject<PFSubclassing>

@property (nonatomic, strong) Contact *contact;
@property (nonatomic, strong) PFRelation *readUsers;    //읽은 유저. Role에 있는 유저, 그룹과 비교할것.
@property (nonatomic, assign) BOOL deleteFlag;          //default NO.
@property (nonatomic, strong) PFACL *ACL;               //set Role.

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
