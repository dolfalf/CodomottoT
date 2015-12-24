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
#import "const.h"

extern NSString * const kCMTRoleNameHeadTeacher;
extern NSString * const kCMTRoleNameTeacher;
extern NSString * const kCMTRoleNameParents;
extern NSString * const kCMTRoleNameMember;

@interface CMTParseManager : NSObject

@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, assign, readonly) UserType userType;
@property (nonatomic, strong, readonly) School *currentSchool;
@property (nonatomic, strong, readonly) User *loginUser;

+ (CMTParseManager *)sharedInstance;

@end

#pragma mark - User Category
@interface CMTParseManager (User)

/*!
 
 @abstract 層属している園を登録
 
 */

- (void)registUserSchool:(School *)school;

- (void)fetchUsers:(UserType)userType withCompletion:(void(^)(NSArray* users, NSError* resultError))completion;

/*!
 
 @abstract アカウント生成
 
 */
- (void)signInUserWithUserEmailAddress:(NSString *)email
                          withPassword:(NSString *)userpassword
                          withUserType:(UserType)userType
                        withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;
/*!
 
 @abstract 유저 상세 데이터 입력기능 - 이 기능은 유저가 로그인 한 상태(currentUser)를 전제로 한다.
 
 */
- (void)setDetailUserInfoWithUserType:(NSNumber *)cmtUserType
                       withWorkSchool:(School *)cmtWorkSchool
                         withUserName:(NSString *)cmtUserName
                 withFuriganaUserName:(NSString *)cmtFuriganaUserName
                           withGender:(NSNumber *)cmtGender
                       withPostalCode:(NSString *)cmtPostalCode
                 withCellPhoneAddress:(NSString *)cmtCellPhoneAddress
                         withPicImage:(NSData *)cmtPicImage
                    withCheckApproval:(NSNumber *)cmtCheckApproval
                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract ログイン
 
 */
- (void)loginWithUserEmailAddress:(NSString *)email
                     withPassword:(NSString *)userpassword
                   withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract ログアウト
 
 */
- (void)logoutCurrentUserWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 비밀번호 리셋 기능
 
 */
- (void)currentUserPasswordResetWithUserEmailAddress:(NSString *)email
                                      withCompletion:(void(^)(BOOL isSucceeded,NSError* resultError))completion;

@end

#pragma mark - Role Category
@interface CMTParseManager (Role)

/*!
 * 現在園のアクセス権限があるかどうか。
 */
- (void)hasAccessRoleToSchoolInBackground:(void(^)(BOOL))completion;
- (BOOL)hasAccessRoleToSchool;
/*!
 * ロールは園長のみ作成できる。
 */
- (void)createRoleForSchoolInBackground:school block:(void(^)(BOOL, NSError*))completion;
- (BOOL)createRoleForSchool:(School *)school error:(NSError **)error;

/*!
 * ロールにユーザーを追加する。
 */
- (void)addUserSchoolRoleInBackground:(RequestUser *)requestUser block:(void(^)(BOOL, NSError*))completion;
- (BOOL)addUserSchoolRole:(RequestUser *)requestUser error:(NSError **)error;

/*!
 
 @abstract 로그인 유저에 쓰기권한을 가진경우 롤 삭제기능
 
 */
+(void)removeRoleWithRoleName:(NSString *)roleName
               withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;


@end
