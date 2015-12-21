//
//  ParseManager.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseModel.h"
#import "const.h"
#import "NSError+Parse.h"

@interface CMTParseManager : NSObject

@property (nonatomic, strong, readonly) User *loginUser;
@property (nonatomic, strong) School *currentSchool;
//프로퍼티들 취득 전에 로그인 중인지 아닌지를 확인하는 외부 엑세스 플래그 필요

+ (CMTParseManager *)sharedInstance;

#pragma mark - Account
- (void)fetchUsers:(UserType)userType withCompletion:(void(^)(NSArray* users, NSError* resultError))completion;
/*
 근무시간 설정 (cmtStartDate, cmtEndDate)은 별개의 시간설정 메소드를 준비한다.
 (현재 미구현)
 */

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
                                      withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

//Role
#pragma mark - Create Role
+(void)createDefaultUserReadOnlyRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

+(void)createTeacherReadOnlyRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

+(void)createTeacherRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

+(void)createMasterTeacherRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

+(void)createSelectUserReadOnlyRoleWithUsers:(NSArray *)usersArray
                              withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

+(void)createSchoolRoleWithRoleName:(NSString*)roleName
                     withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

//+(void)createPublicUserReadOnlyRoleWithError:(NSError **)resultError;

#pragma mark - Add User
/*!
 
 @abstract 일반유저(읽기전용)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addDefaultUserReadOnlyRoleUsersWithUserInformation:(User *)user
                                           withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 선생유저(읽기전용)롤에 유저 추가 기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addTeacherReadOnlyRoleUsersWithUserInformation:(User *)user
                                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 선생유저(읽기,쓰기)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addTeacherRoleUsersWithUserInformation:(User *)user
                               withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 원장유저(읽기,쓰기)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addMasterTeacherRoleUsersWithUserInformation:(User *)user
                                     withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

//+(void)addSchoolRoleUsersWithUserInformation:(User *)user
//                                   withError:(NSError **)resultError;

/*!
 
 @abstract 전체유저(읽기전용)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addPublicUserReadOnlyRoleUsersWithUserInformation:(User *)user
                                          withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

#pragma mark - Remove Role

/*!
 
 @abstract 로그인 유저에 쓰기권한을 가진경우 롤 삭제기능
 
 */
+(void)removeRoleWithRoleName:(NSString *)roleName
               withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;


@end
