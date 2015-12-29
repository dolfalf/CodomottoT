//
//  Child.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "Child.h"
#import "CMTParseManager.h"

@implementation Child

@dynamic cmtSchool;
@dynamic cmtGroup;
@dynamic parentsUser;
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
    
    Child *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}
@end
