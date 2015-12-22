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
    
    //自分のみアクセスできる
    PFACL *school_ACL = [PFACL ACL];
    [school_ACL setWriteAccess:YES forUser:[User currentUser]];
    [school_ACL setReadAccess:YES forUser:[User currentUser]];
    school.ACL = school_ACL;   //default
    
    [self save:school completion:^(BOOL succeeded, NSError *resultError) {
        if (succeeded) {
            //Schoolが作成できたらロールを作成する。
            [mgr createSchoolRole:school completion:^(BOOL succeeded, NSError *resultError) {
                
                if (completion) {
                    completion(succeeded, resultError);
                }
            }];
        }else {
            if (completion) {
                completion(succeeded, resultError);
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
        
        for (Role *role in objects) {
            if ([role.name hasPrefix:kCMTRoleNameMember]) {
                //Read権限
                [work_acl setReadAccess:YES forRole:role];
                continue;
            }
            if ([role.name hasPrefix:kCMTRoleNameTeacher]) {
                //Write権限
                [work_acl setWriteAccess:YES forRole:role];
                continue;
            }
            
        }
        school.ACL = work_acl;
        [school save];
        
    }];
}

@end
