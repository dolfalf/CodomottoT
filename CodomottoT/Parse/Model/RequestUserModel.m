//
//  RequestUserModel.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "RequestUserModel.h"
#import "RequestUser.h"

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

- (void)save:(PFObject *)object completion:(void (^)(BOOL, NSError *))completion {

    //権限設定
//    RequestUser *user = (RequestUser *)object;
//    PFACL *work_acl = [PFACL ACL];
//    work_acl setaccess
//    [super save:object completion:completion];
}

@end
