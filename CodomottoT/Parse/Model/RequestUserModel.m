//
//  RequestUserModel.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "RequestUserModel.h"
#import "RequestUser.h"
#import "CMTParseManager.h"

@implementation RequestUserModel

- (void)fetchBySchool:(School *)school completion:(void(^)(NSArray* requestUsers, NSError* resultError))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
    [query whereKey:@"cmtSchool" equalTo:school];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
}

- (void)approvedInBackground:(RequestUser *)object {
    
    object.approvedFlag = YES;
    [object saveInBackground];
}

#pragma mark - override methods
- (void)save:(PFObject *)object completion:(void (^)(BOOL, NSError *))completion {

    CMTParseManager *mgr = [CMTParseManager sharedInstance];
    if (mgr.currentSchool == nil) {
        NSLog(@"No exist school info.");
        if (completion) {
            completion(NO, [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"No exist school info."]);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //権限設定
        RequestUser *user = (RequestUser *)object;
        user.ACL = [mgr.loginUser ACL]; //default.
        
        PFQuery *role_query = [PFRole query];
        [role_query whereKey:@"cmtSchool" equalTo:mgr.currentSchool];
        
        NSArray *school_roles = [role_query findObjects];
        
        
        if (school_roles == nil || school_roles.count == 0) {
            if (completion) {
                completion(NO, [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"No exist school role."]);
            }
            return;
        }
        
        for (PFRole *s_role in school_roles) {
            if ([s_role.name hasPrefix:kCMTRoleNameHeadTeacher]) {
                PFACL *work_acl = [PFACL ACL];
                [work_acl setReadAccess:YES forRole:s_role];
                [work_acl setWriteAccess:YES forRole:s_role];
                
                user.ACL = work_acl;
                break;
            }
        }
        
        //保存
        NSError *user_error = nil;
        [user save:&user_error];
        
        
        if (completion) {
            completion(YES, nil);
        }
    });

}

@end
