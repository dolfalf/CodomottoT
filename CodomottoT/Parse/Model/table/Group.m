//
//  Group.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Group.h"
#import "School.h"
#import "User.h"

@implementation Group

@dynamic school;
@dynamic teachers;
@dynamic name;
@dynamic deleteFlag;
@dynamic ACL;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Group";
}

+ (instancetype)createModel {
    
    Group *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
