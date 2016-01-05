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
#import "CMTParseManager.h"

@implementation ContactRead

@dynamic contact;
@dynamic readUsers;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    ContactRead *model = [[self alloc] init];
    
    model.deleteFlag = NO;
    model.ACL = [[CMTParseManager sharedInstance] schoolDefaultACL];
    
    return model;
}

@end
