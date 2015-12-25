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
@dynamic comments;
@dynamic noticeFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);;
}

+ (instancetype)createModel {
    
    Contact *model = [[self alloc] init];
    
    model.noticeFlag = NO;
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
