//
//  RequestUserModel.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/21.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "Model.h"
#import "RequestUser.h"

@interface RequestUserModel : Model

- (void)fetchByCurrentSchool:(void(^)(NSArray *requestUsers, NSError* err))block;
- (void)approvedInBackground:(RequestUser *)object;
@end
