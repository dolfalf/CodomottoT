//
//  Contact.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Contact.h"
#import <Parse/PFObject+Subclass.h>
#import "User.h"
#import "ContactPhoto.h"
#import "ContactRead.h"

@implementation Contact

@dynamic title;
@dynamic content;
@dynamic postUser;
@dynamic photos;
@dynamic contactRead;
@dynamic noticeFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Contact";
}

+ (instancetype)createModel {
    
    Contact *model = [[self alloc] init];
    
    //여기서 초기화 처리를 해준다.
    model.noticeFlag = NO;
    model.deleteFlag = NO;
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        //initialize.
        //여기서 초기화가 안된다.. 쿼리에서 에러남.
    }
    
    return self;
}

@end
