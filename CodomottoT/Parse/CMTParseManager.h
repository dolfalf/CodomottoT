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

//Account
#pragma mark - Account
/*
 근무시간 설정 (cmtStartDate, cmtEndDate)은 별개의 시간설정 메소드를 준비한다.
 (현재 미구현)
 */

/*!
 
 @abstract 어카운트 생성 기능
 
 */
+(void)signInUserWithUserEmailAddress:(NSString *)email
                         withPassword:(NSString *)userpassword
                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 로그인 기능
 
 */
+(void)loginWithUserEmailAddress:(NSString *)email
                    withPassword:(NSString *)userpassword
                  withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 유저 상세 데이터 입력기능 - 이 기능은 유저가 로그인 한 상태(currentUser)를 전제로 한다.
 
 */
+(void)setDetailUserInfoWithUserType:(NSNumber *)cmtUserType
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
 
 @abstract 로그아웃 기능
 
 */
+(void)logoutCurrentUserWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion;

/*!
 
 @abstract 비밀번호 리셋 기능
 
 */
+(void)currentUserPasswordResetWithUserEmailAddress:(NSString *)email
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


#pragma mark - Test API'S

/*!
 
 @abstract 테스트용 api - 원장유저 생성
 
 */
+(void)createMasterTeacher;

/*!
 
 @abstract 테스트용 api - 선생유저 생성
 
 */
+(void)createTeacher;

/*!
 
 @abstract 테스트용 api - 부모유저 생성
 
 */
+(void)createParents;

/*!
 
 @abstract 테스트용 api - 원장유저 로그인
 
 */
+(void)loginMasterTeacherWithCompletion:(void(^)(BOOL isSucceeded, NSError *resultError))completion;

/*!
 
 @abstract 테스트용 api - 선생유저 로그인
 
 */
+(void)loginTeacherWithCompletion:(void(^)(BOOL isSucceeded, NSError *resultError))completion;

/*!
 
 @abstract 테스트용 api - 부모유저 로그인
 
 */
+(void)loginParentsWithCompletion:(void(^)(BOOL isSucceeded, NSError *resultError))completion;

/*!
 
 @abstract 테스트용 api - 유저네임으로 유저 오브젝트 검색기능
 
 */
+(User*)getUserObjectWithUserName:(NSString*)userName;
/*!

 @abstract Deletes a collection of objects all at once *asynchronously* and executes the block when done.
 
 @param objects The array of objects to delete.
 @param block The block to execute.
 It should have the following argument signature: `^(BOOL succeeded, NSError *error)`.
 */
//+ (void)deleteAllInBackground:(PF_NULLABLE NSArray *)objects
//                        block:(PF_NULLABLE PFBooleanResultBlock)block;

/*!
 @abstract Unsets a key on the object.
 
 @param key The key.
 */
//- (void)removeObjectForKey:(NSString *)key;


@end
