//
//  RequestUser.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@class School;

@interface RequestUser : PFObject<PFSubclassing>

@property (nonatomic, strong) User *requestUser;
@property (nonatomic, strong) School *registSchool;
@property (nonatomic, assign) BOOL approvedFlag;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;

@end
