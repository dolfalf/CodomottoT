//
//  Role.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Role.h"
#import "User.h"

@implementation Role

//  objectId (auto)
@dynamic name;
@dynamic roles;
@dynamic users;
@dynamic ACL;
//  createAt (auto)
//  updateAt (auto)

+ (void)load {
    [self registerSubclass];
}

@end
