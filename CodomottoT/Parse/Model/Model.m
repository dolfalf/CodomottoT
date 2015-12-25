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
- (void)fetchAll:(void(^)(NSArray* objects, NSError* err))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(objects, error);
            }
        });
    }];
    
}

- (void)save:(id)object block:(errorBlock)block {
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        });
    }];
}

- (void)remove:(PFObject *)object block:(errorBlock)block {
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        });
    }];
}

- (void)removeAll:(errorBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [PFQuery queryWithClassName:[self parseObjectName]];
        NSArray *delete_models = [query findObjects];
        
        NSError *error = nil;
        [PFObject deleteAll:delete_models error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        }); 
    });
}

@end
