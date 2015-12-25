//
//  SchoolModel.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "SchoolModel.h"
#import "CMTParseManager.h"

@implementation SchoolModel

- (void)registSchool:(School *)school block:(errorBlock)block {
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    if (mgr.userType != UserTypeHeadTeacher) {
        if (block) {
            block([NSError errorWithCodomottoErrorCode:CMTErrorCodeNoAuth localizedDescription:@"No Auth."]);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *school_error = nil;
        BOOL school_successed = NO;
        school_successed = [school save:&school_error];
        
        if (school_successed == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(school_error);
                }
            });
            
        }
        
        //ロール生成
        NSError *role_error = nil;
        BOOL role_successed = [mgr createRoleForSchool:school error:&role_error];
        
        if (role_successed == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(school_error);
                }
            });
        }
        
        PFQuery *query = [Role query];
        [query whereKey:@"cmtSchool" equalTo:school];
        NSError *is_exist_error = nil;
        NSArray *objects = [query findObjects:&is_exist_error];
        
        NSLog(@"role object[%ld]", (long)objects.count);
        
        PFACL *school_acl = [PFACL ACL];
        [school_acl setPublicReadAccess:YES];
        
        for (Role *role in objects) {
            
            if ([role.name hasPrefix:kCMTRoleNameMember]) {
                //Read権限
                [school_acl setReadAccess:YES forRole:role];
                continue;
            }
            
            if ([role.name hasPrefix:kCMTRoleNameTeacher]) {
                //Write権限
                [school_acl setWriteAccess:YES forRole:role];
                continue;
            }
            
        }
        
        school.ACL = school_acl;
        [school save];
    
        //ユーザーに登録
        [mgr registUserSchool:school];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil);
            }
        });
    });
}

@end
