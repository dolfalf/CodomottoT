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
@dynamic approvedFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    RequestUser *model = [[self alloc] init];
    
    //default
    model.approvedFlag = NO;
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //ここでは初期化をしない。クエリー時エラーの原因となる。
    }
    return self;
}

@end
