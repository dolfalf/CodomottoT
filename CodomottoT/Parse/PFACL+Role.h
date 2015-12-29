//
//  PFACL+Role.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <Parse/Parse.h>

@class User;
@class Role;

@interface PFACL (Role)

+ (PFACL *)userACL;
+ (PFACL *)publicReadOnlyACL;
+ (PFACL *)publicReadWriteACL;

- (PFACL *)addReadOnlyRoleWithName:(NSString *)roleName;
- (PFACL *)addWriteRoleWithName:(NSString *)roleName;

- (PFACL *)addReadOnlyRole:(Role *)role;
- (PFACL *)addWriteRole:(Role *)role;
@end
