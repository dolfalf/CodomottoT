//
//  Model.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Model : NSObject

- (NSString *)parseObjectName;

- (void)fetchAll:(void(^)(NSArray* objects, NSError* resultError))completion;
- (void)save:(PFObject *)object completion:(void(^)(BOOL succeeded, NSError* resultError))completion;
- (void)remove:(PFObject *)object completion:(void(^)(BOOL succeeded, NSError* resultError))completion;
- (void)removeAll:(void(^)(BOOL succeeded,NSError* resultError))completion;

@end
