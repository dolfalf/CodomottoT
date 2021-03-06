//
//  ParseManager.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+Parse.h"
#import "ParseModel.h"
#import "PFACL+Role.h"
#import "const.h"
#import "Model.h"

extern NSString * const kCMTRoleNameHeadTeacher;
extern NSString * const kCMTRoleNameTeacher;
extern NSString * const kCMTRoleNameParents;
extern NSString * const kCMTRoleNameMember;

@interface CMTParseManager : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, assign, readonly) UserType userType;
@property (nonatomic, strong, readonly) User *currentCmtUser;
@property (nonatomic, strong, readonly) School *currentSchool;

+ (CMTParseManager *)sharedInstance;

- (NSString *)currentStatusDescription;
@end

#pragma mark - User Category
@interface CMTParseManager (User)

/*!
 @abstract 現在粗属している園をロード
 */
- (void)loadCurrentSchool;

/*!
 @abstract 現在ユーザーに園を登録
 */
- (void)registUserSchool:(School *)school error:(NSError **)error;

/*!
 @abstract リクエストユーザーを登録
 */
- (void)registRequestUser:(School *)school block:(errorBlock)block;

- (void)fetchUsers:(UserType)userType block:(void(^)(NSArray* users, NSError* error))block;

/*!
 @abstract アカウント生成
 */
- (void)signUp:(NSString *)email password:(NSString *)password userType:(UserType)utype block:(errorBlock)block;

/*!
 @abstract ログイン
 */
- (void)signIn:(NSString *)email password:(NSString *)password block:(errorBlock)block;

/*!
 @abstract ログアウト
 */
- (void)signOut:(void(^)(void))block;

/*!
 @abstract パスワードリセット
 */
- (void)resetPassword:(NSString *)email block:(errorBlock)block;

@end

#pragma mark - Role Category
@interface CMTParseManager (Role)

/*!
 * 現在園のアクセス権限があるかどうか。
 */
- (void)hasAccessRoleToSchoolInBackground:(boolBlock)block;
- (BOOL)hasAccessRoleToSchool;

/*!
 * 園に必要なロールを生成
 */
- (void)createRoleForSchoolInBackground:school block:(errorBlock)block;
- (BOOL)createRoleForSchool:(School *)school error:(NSError **)error;

/*!
 * ロールにユーザーを追加
 */
- (void)addUserSchoolRoleInBackground:(RequestUser *)requestUser block:(errorBlock)block;
- (BOOL)addUserSchoolRole:(RequestUser *)requestUser error:(NSError **)error;

/*!
 * ロールの削除
 * まだ検証してないメソッド
 */
- (void)removeSchoolRole:(School *)school block:(errorBlock)block;

@end

#pragma mark - ACL Category
@interface CMTParseManager (ACL)

- (PFACL *)registSchoolACL;
- (PFACL *)schoolDefaultACL;
@end
