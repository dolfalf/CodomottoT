//
//  RequestUser.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "RequestUser.h"

@implementation RequestUser

@dynamic requestUser;
@dynamic registSchool;
@dynamic ApprovedFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"RequestUser";
}

+ (instancetype)createModel {
    
    RequestUser *model = [[self alloc] init];
    
    //default
    model.ApprovedFlag = NO;
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
