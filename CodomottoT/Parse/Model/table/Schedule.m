//
//  Schedule.m
//  Codomotto
//
//  Created by kjcode on 2015/09/24.
//  Copyright © 2015年 Codomotto. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

@dynamic title;
@dynamic description;
@dynamic location;
@dynamic alldayFlag;
@dynamic startDate;
@dynamic endDate;
@dynamic repeatFlag;
@dynamic notifyFlag;

@dynamic noticeFlag;
@dynamic deleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Schedule";
}

+ (instancetype)createModel {
    
    Schedule *model = [[self alloc] init];
    
    model.noticeFlag = NO;
    model.deleteFlag = NO;
    model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
