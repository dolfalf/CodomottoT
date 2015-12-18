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

@interface Notice : PFObject<PFSubclassing>

//  objectId (auto)
@property (nonatomic, strong) NSString *relationTable;
@property (nonatomic, strong) NSString *relationId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) School *viewSchools;
@property (nonatomic, strong) Group *viewGroups;
@property (nonatomic, strong) User *viewUsers;
@property (nonatomic, assign) BOOL *viewAll;
@property (nonatomic, strong) PFACL *ACL;
//  createAt (auto)
//  updateAt (auto)

+ (NSString *)parseClassName;

@end
