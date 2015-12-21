//
//  SchoolModel.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "SchoolModel.h"
#import "School.h"
#import "const.h"

@implementation SchoolModel

- (void)fetchAll:(void(^)(NSArray* schools, NSError* resultError))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:[School parseClassName]];
#if 0
    [query whereKey:@"" equalTo:@""];
#endif
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            NSLog(@"Successfully retrieved %ld school.", (long)objects.count);
#if 1
            for (School *school in objects) {
                NSLog(@"%@", school.name);
            }
#endif
        
            if (completion) {
                completion(objects, nil);
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            if (completion) {
                completion(nil, error);
            }
        }
    }];
    
}

- (void)registSchool:(NSDictionary *)info completion:(void(^)(BOOL succeeded, NSError* resultError))completion {
    
    School *school = [School createModel];
    
//    SET_MODEL_PARAM(school, info, name);
//    SET_MODEL_PARAM(school, info, description);
    
    school.name = info[@"name"];
    school.description = info[@"description"];

    [school saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            if (completion) {
                completion(succeeded, error);
            }
        }else {
            if (completion) {
                completion(NO, error);
            }
        }
        
    }];
}

@end
