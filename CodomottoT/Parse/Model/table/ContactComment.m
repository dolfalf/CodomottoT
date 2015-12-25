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
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    ContactComment *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
