//
//  Model.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef void (^errorBlock)(NSError *);
typedef void (^boolBlock)(BOOL);

@interface Model : NSObject

- (NSString *)parseObjectName;

- (void)fetchAll:(void(^)(NSArray* objects, NSError* err))block;
- (void)save:(id)object block:(errorBlock)block;
- (void)remove:(id)object block:(errorBlock)block;
- (void)removeAll:(errorBlock)block;

@end
