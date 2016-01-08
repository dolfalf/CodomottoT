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
        [query whereKey:@"approvedFlag" equalTo:@(NO)];
        
        NSError *error = nil;
        NSArray *objects = [query findObjects:&error];
        
        //参照しているデータがObjectIdしかなかったため、この処理を入れた。
        for (RequestUser *ruser in objects) {
            ruser.requestUser = [ruser.requestUser fetchIfNeeded];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(objects, error);
            }
        });
    });
}

- (void)approvedInBackground:(RequestUser *)object {
    
    object.approvedFlag = YES;
    [object saveInBackground];
}

@end
