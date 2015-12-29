//
//  Child.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <Parse/Parse.h>

@class School;
@class Group;

/*!
 * 園児情報クラス
 */
 
@interface Child : PFObject<PFSubclassing>

@property (nonatomic, strong) School *cmtSchool;
@property (nonatomic, strong) Group *cmtGroup;
@property (nonatomic, strong) PFRelation *parentsUser;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
