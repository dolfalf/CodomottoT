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
#import "CMTParseManager.h"

@implementation Group

@dynamic cmtSchool;
@dynamic teachers;
@dynamic childs;
@dynamic name;
@dynamic deleteFlag;
@dynamic ACL;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    Group *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    model.ACL = [[CMTParseManager sharedInstance] schoolDefaultACL];
    
    return model;
}

@end
