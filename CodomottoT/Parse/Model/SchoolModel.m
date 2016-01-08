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
        
        //set acl
        school.ACL = [mgr registSchoolACL];
        
        //save school
        [school save];
        
        //ユーザーに園を登録
        NSError *user_error = nil;
        [mgr registUserSchool:school error:&user_error];
        
        if (user_error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(user_error);
                }
            });
        }
        
        //成功
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil);
            }
        });
    });
}

@end
