//
//  ContactRead.m
//  Codomotto
//
//  Created by kjcode on 2015/07/27.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactRead.h"
#import <Parse/PFObject+Subclass.h>
#import "Contact.h"
#import "User.h"

@implementation ContactRead

@dynamic contact;
@dynamic readUsers;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ContactRead";
}

+ (instancetype)createModel {
    
    ContactRead *model = [[self alloc] init];
    
    //여기서 초기화 처리를 해준다.
    model.deleteFlag = NO;
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
