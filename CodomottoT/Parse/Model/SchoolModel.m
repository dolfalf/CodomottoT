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

- (void)registSchool:(School *)school completion:(void(^)(BOOL succeeded, NSError* resultError))completion {
    
    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    
    if (mgr.userType != UserTypeHeadTeacher) {
        if (completion) {
            completion(NO, [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoAuth localizedDescription:@"No Auth."]);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //自分のみアクセスできる
        PFACL *school_ACL = [PFACL ACL];
        [school_ACL setWriteAccess:YES forUser:[User currentUser]];
        [school_ACL setReadAccess:YES forUser:[User currentUser]];
        school.ACL = school_ACL;   //default
        
        NSError *school_error = nil;
        BOOL school_successed = NO;
        school_successed = [school save:&school_error];
        
        if (school_successed == NO) {
            if (completion) {
                completion(school_successed, school_error);
            }
        }
        
        //ロール生成
        NSError *role_error = nil;
        BOOL role_successed = [mgr createRoleForSchool:school error:&role_error];
        
        if (role_successed == NO) {
            if (completion) {
                completion(role_successed, school_error);
            }
        }
        
        
        //여기가 잘 안됨!!
        PFQuery *query = [Role query];
        [query whereKey:@"cmtSchool" equalTo:school];
        NSError *is_exist_error = nil;
        NSArray *objects = [query findObjects:&is_exist_error];
        
        //왜 롤이 검색이 안되지????
        NSLog(@"role object[%ld]", (long)objects.count);
        
        PFACL *work_acl = [PFACL ACL];
        
        //初めてログインしたUserは一覧で見ることができないため
        [work_acl setPublicReadAccess:YES];
        
        for (Role *role in objects) {
            
#if 0
            if ([role.name hasPrefix:kCMTRoleNameMember]) {
                //Read権限
                [work_acl setReadAccess:YES forRole:role];
                continue;
            }
#endif
            if ([role.name hasPrefix:kCMTRoleNameTeacher]) {
                //Write権限
                [work_acl setWriteAccess:YES forRole:role];
                continue;
            }
            
        }
        school.ACL = work_acl;
        [school save];
    
    });
}

@end
