//
//  ContactComment.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactComment.h"
#import "Contact.h"
#import "User.h"
#import "CMTParseManager.h"

@implementation ContactComment

@dynamic comment;
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
    model.ACL = [[CMTParseManager sharedInstance] postContactACL];
    
    return model;
}

@end
