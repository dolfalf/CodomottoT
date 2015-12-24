//
//  StoryboardUtil.h
//  CodomottoT
//
//  Created by Lee jaeeun on 2014/06/27.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardUtil : NSObject

@end

@interface StoryboardUtil (Sign)
+ (void)openSignInViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;

@end

@interface StoryboardUtil (ISW)

+ (void)pushSignUpViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;
+ (void)pushRegistSchoolViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;
+ (void)pushSchoolListViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;
+ (void)pushAllowWaitViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;
+ (void)pushStartContactViewController:(id)owner animated:(BOOL)animated completion:(void(^)(id))completion;
@end

@interface StoryboardUtil (Setting)

+ (void)openRequestUserViewController:(id)owner completion:(void(^)(id))completion;
@end

@interface StoryboardUtil (Contact)

+ (void)openContactViewController:(id)owner completion:(void(^)(id))completion;
@end

@interface StoryboardUtil (Debug)

+ (void)openUserListViewController:(id)owner completion:(void(^)(id))completion;
@end
