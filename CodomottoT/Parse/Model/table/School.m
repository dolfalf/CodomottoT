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
@dynamic address3;
@dynamic kana1;
@dynamic kana2;
@dynamic kana3;
@dynamic prefcode;
@dynamic zipcode;
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

@end
