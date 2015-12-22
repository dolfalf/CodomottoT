//
//  Model.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "Model.h"

@implementation Model

- (NSString *)parseObjectName {
    return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Model" withString:@""];
}

#pragma mark - class methods
- (void)fetchAll:(void(^)(NSArray* objects, NSError* resultError))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (completion) {
            completion(objects, error);
        }
    }];
    
}

- (void)save:(PFObject *)object completion:(void(^)(BOOL succeeded, NSError* resultError))completion {
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (completion) {
            completion(succeeded, error);
        }
    }];
}

- (void)remove:(PFObject *)object completion:(void(^)(BOOL succeeded, NSError* resultError))completion {
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (completion) {
            completion(succeeded, error);
        }
    }];
    
}

- (void)removeAll:(void(^)(BOOL succeeded,NSError* resultError))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
        NSArray *delete_models = [query findObjects];
        
        NSError *error = nil;
        [PFObject deleteAll:delete_models error:&error];
        
        if (completion) {
            completion(error==nil?YES:NO, error);
        }
    });
    
}

@end
