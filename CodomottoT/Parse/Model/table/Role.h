//
//  Role.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@interface Role : PFRole

//  objectId (auto)
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong, readonly) PFRelation *users;
@property (nonatomic, strong, readonly) PFRelation *roles;
@property (nonatomic, strong) PFACL *ACL;
//  createAt (auto)
//  updateAt (auto)

@end
