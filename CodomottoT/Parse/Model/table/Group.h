//
//  Group.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class School;
@class User;

/*!
 * 園内の教室クラス
 */
@interface Group : PFObject<PFSubclassing>

@property (nonatomic, strong) School *cmtSchool;
@property (nonatomic, strong) PFRelation *teachers;
@property (nonatomic, strong) PFRelation *childs;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
