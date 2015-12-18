//
//  ContactComment.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactComment.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"
#import "Contact.h"

@implementation ContactComment

@dynamic title;
@dynamic content;
@dynamic postContact;
@dynamic postUser;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ContactComment";
}

+ (instancetype)createModel {
    
    ContactComment *model = [[self alloc] init];
    
    //여기서 초기화 처리를 해준다.
    model.deleteFlag = NO;
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
