//
//  ChildModel.h
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/05.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "Model.h"
#import "Child.h"

@interface ChildModel : Model

- (void)fetchRegistTargetChild:(Group *)group block:(void(^)(NSArray *requestUsers, NSError* err))block;
@end
