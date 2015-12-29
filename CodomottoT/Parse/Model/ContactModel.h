//
//  ContactModel.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "Contact.h"
#import "ContactComment.h"
#import "ContactPhoto.h"

/*!
 * 連絡帳に関連するモデルアクセスクラス
 */
@interface ContactModel : Model

@property (nonatomic, assign) NSInteger fetchContactLimit;


/*!
 * 連絡帳情報を返す
 * @param NSInteger 開始インデックス（ページング処理のため）
 */
- (void)fetchContacts:(NSInteger)startIndex block:(void(^)(NSArray *, NSError *))block;

/*!
 * 連絡帳を作成する
 */
- (void)postContact:(NSString *)content photoItems:(NSArray *)photoItems block:(boolBlock)block;

#if 0
- (void)removeContact:(id)model block:(boolBlock)block;
- (void)modifyContact:(id)model block:(boolBlock)block;
#endif

@end

#pragma mark - Comment Category
@interface ContactModel (Comment)

- (void)addComment:(NSString *)comment contact:(id)contact block:(boolBlock)block;
- (void)modifyComment:(NSString *)comment model:(ContactComment *)model block:(boolBlock)block;
- (void)removeComment:(ContactComment *)model block:(boolBlock)block;

@end
