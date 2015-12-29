//
//  Notice.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Notice.h"
#import <Parse/PFObject+Subclass.h>
#import "School.h"
#import "Group.h"
#import "User.h"

@implementation Notice

@dynamic relationTable;
@dynamic relationId;
@dynamic title;
@dynamic content;
@dynamic viewSchools;
@dynamic viewGroups;
@dynamic viewUsers;
@dynamic viewAll;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    Notice *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
