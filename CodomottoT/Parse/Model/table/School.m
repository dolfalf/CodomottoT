//
//  School.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "School.h"

@implementation School

@dynamic name;
@dynamic address1;
@dynamic address2;
@dynamic zipCode;
@dynamic location;
@dynamic description;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    School *model = [[self alloc] init];
    
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
