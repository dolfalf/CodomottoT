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

- (void)fetchByCurrentSchool:(void(^)(NSArray* requestUsers, NSError* err))block {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        CMTParseManager *mgr = [CMTParseManager sharedInstance];
        
        NSError *school_error = nil;
        School *current_school = mgr.currentSchool;
        if (school_error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(nil, [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"No school data."]);
                }
            });
            return;
        }
        
        PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
        [query whereKey:@"registSchool" equalTo:current_school];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(objects, error);
                }
            });
        }];
    });
}

- (void)approvedInBackground:(RequestUser *)object {
    
    object.approvedFlag = YES;
    [object saveInBackground];
}

#pragma mark - override methods
- (void)save:(RequestUser *)object block:(errorBlock)block {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CMTParseManager *mgr = [CMTParseManager sharedInstance];
        
        NSError *school_error = nil;
        School *current_school = mgr.currentSchool;
        if (school_error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block([NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"No school data."]);
                }
            });
            return;
        }
        
        //権限設定
        RequestUser *req_user = (RequestUser *)object;
        
        PFQuery *role_query = [PFRole query];
        [role_query whereKey:@"cmtSchool" equalTo:current_school];
        
        NSArray *school_roles = [role_query findObjects];
        
        if (school_roles == nil || school_roles.count == 0) {
            if (block) {
                block([NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"No exist school role."]);
            }
            return;
        }
        
        for (PFRole *s_role in school_roles) {
            if ([s_role.name hasPrefix:kCMTRoleNameHeadTeacher]) {
                PFACL *work_acl = [PFACL ACL];
                [work_acl setReadAccess:YES forRole:s_role];
                [work_acl setWriteAccess:YES forRole:s_role];
                
                req_user.ACL = work_acl;
                break;
            }
        }
        
        //保存
        NSError *user_error = nil;
        [req_user save:&user_error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil);
            }
        });
    });

}

@end
