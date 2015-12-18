//
//  ContactModel.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "ContactComment.h"

extern NSString * const kContactImageAssetKey;
extern NSString * const kContactImageDataKey;

@interface ContactModel : NSObject

#pragma mark - post
- (void)contactListWithStartIndex:(NSInteger)startIndex block:(void(^)(NSArray *, NSError *))block;
- (void)postContact:(NSString *)title content:(NSString *)content imageItems:(NSArray *)items completion:(void(^)(BOOL))completion;

//- (void)removeContact:(id)model;
//- (void)modifyContact:(id)model;


#pragma mark - comment
- (void)addComment:(NSString *)comment contact:(id)contact completion:(void(^)(BOOL))completion;
- (void)modifyComment:(NSString *)comment model:(ContactComment *)model;
- (void)removeComment:(ContactComment *)model;

@end
