//
//  PFACL+Role.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "PFACL+Role.h"
#import "User.h"

@implementation PFACL (Role)

+ (PFACL *)userACL {
    
    PFACL *acl = [PFACL ACL];
    
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    return acl;
}

+ (PFACL *)publicReadOnlyACL {
    
    PFACL *acl = [PFACL userACL];
    
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:NO];
    
    return acl;
}

+ (PFACL *)publicReadWriteACL {
    
    PFACL *acl = [PFACL userACL];
    
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:YES];
    
    return acl;
}

- (PFACL *)addReadOnlyRoleWithName:(NSString *)roleName {
    
    [self setReadAccess:YES forRoleWithName:roleName];
    [self setWriteAccess:NO forRoleWithName:roleName];
    
    return self;
}

- (PFACL *)addWriteRoleWithName:(NSString *)roleName {
    
    [self setReadAccess:YES forRoleWithName:roleName];
    [self setWriteAccess:YES forRoleWithName:roleName];
    
    return self;
}

- (PFACL *)addReadOnlyRole:(Role *)role {
    
    [self setReadAccess:YES forRole:(PFRole *)role];
    [self setWriteAccess:NO forRole:(PFRole *)role];
    
    return self;
}

- (PFACL *)addWriteRole:(Role *)role {
    
    [self setReadAccess:YES forRole:(PFRole *)role];
    [self setWriteAccess:YES forRole:(PFRole *)role];
    
    return self;
}

@end
