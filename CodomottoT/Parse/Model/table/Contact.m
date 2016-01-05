//
//  Contact.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Contact.h"
#import "ContactPhoto.h"
#import "ContactRead.h"
#import "User.h"
#import "CMTParseManager.h"

@implementation Contact

@dynamic content;
@dynamic postUser;
@dynamic photos;
@dynamic contactRead;
@dynamic comments;
@dynamic noticeFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    Contact *model = [[self alloc] init];
    
    model.noticeFlag = NO;
    model.deleteFlag = NO;
    
    model.ACL = [[CMTParseManager sharedInstance] schoolDefaultACL];
    
    return model;
}

@end
