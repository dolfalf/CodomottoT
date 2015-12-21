//
//  SchoolModel.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject

- (void)fetchAll:(void(^)(NSArray* schools, NSError* resultError))completion;
- (void)registSchool:(NSDictionary *)info completion:(void(^)(BOOL succeeded, NSError* resultError))completion;
@end
