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
    
    model.deleteFlag = NO;
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //initialize.
        //여기서 초기화가 안된다.. 쿼리에서 에러남.
    }
    
    return self;
}
@end
