//
//  Notice.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class School;
@class Group;
@class User;

/*!
 * お知らせ表示用クラス
 */
@interface Notice : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *relationTable;
@property (nonatomic, strong) NSString *relationId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) School *viewSchools;
@property (nonatomic, strong) Group *viewGroups;
@property (nonatomic, strong) User *viewUsers;
@property (nonatomic, assign) BOOL *viewAll;
@property (nonatomic, assign) BOOL deleteFlag;          //default NO.
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
