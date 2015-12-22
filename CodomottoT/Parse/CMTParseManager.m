//
//  ParseManager.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "CMTParseManager.h"
#import "Role.h"
#import "User.h"

NSString * const kCMTRoleNameHeadTeacher    = @"HeadTeacher";
NSString * const kCMTRoleNameTeacher        = @"Teacher";
NSString * const kCMTRoleNameParents        = @"Parents";
NSString * const kCMTRoleNameMember         = @"Member";

@implementation CMTParseManager

@dynamic isLogin;
@dynamic userType;
@dynamic loginUser;

static CMTParseManager *_sharedInstance;

#pragma mark - singleton
+ (CMTParseManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super alloc] init];
        //initialize.
    });
    
    return _sharedInstance;
    
}

+ (id)allocWithZone:(NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    
    return _sharedInstance;
    
}

- (id)init {
    self = [super init];
    if (self) {
        NSAssert(YES, @"This is singleton class!!");
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)dealloc {
    
}

#pragma mark - getter Property

- (BOOL)isLogin {
    
    return ([User currentUser]==nil)?NO:YES;
}

- (UserType)userType {
    
    if ([User currentUser] == nil) {
        return UserTypeNone;
    }
    
    return (UserType)[[User currentUser].cmtUserType integerValue];
}

- (User *)loginUser {
    return [User currentUser];
}

- (School *)currentSchool {
    return [User currentUser].cmtWorkSchool;
}

#pragma mark ACL

+(PFACL*)getPublicReadOnlyACL{
    PFACL *acl = [PFACL ACL];
    User *masterTeacher = [User currentUser];
    [acl setWriteAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forUser:masterTeacher];
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:NO];
    
    return acl;
}

+(PFACL*)getPublicReadWriteACL{
    PFACL *acl = [PFACL ACL];
    User *masterTeacher = [User currentUser];
    [acl setWriteAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forUser:masterTeacher];
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:YES];
    
    return acl;
}

+(PFACL*)getReadOnlyACLWithRoleName:(NSString *)roleName{
    PFACL *acl = [PFACL ACL];
    User *masterTeacher = [User currentUser];
    [acl setWriteAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:NO forRoleWithName:roleName];
    [acl setPublicReadAccess:YES];
    
    return acl;
}

+(PFACL*)getReadWriteACLWithRoleName:(NSString *)roleName{
    PFACL *acl = [PFACL ACL];
    User *masterTeacher = [User currentUser];
    [acl setWriteAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forUser:masterTeacher];
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:YES forRoleWithName:roleName];
    [acl setPublicReadAccess:YES];
    
    return acl;
}

+(PFACL*)getReadOnlyACLWithUser:(User *)userObject{
    PFACL *acl = [PFACL ACL];
    [acl setReadAccess:YES forUser:userObject];
    [acl setWriteAccess:NO forUser:userObject];
    
    return acl;
}

+(PFACL*)getReadWriteACLWithUser:(User *)userObject{
    PFACL *acl = [PFACL ACL];
    [acl setReadAccess:YES forUser:userObject];
    [acl setWriteAccess:YES forUser:userObject];
    
    return acl;
}

@end

#pragma mark - Account Category
@implementation CMTParseManager (Account)

- (void)fetchUsers:(UserType)userType withCompletion:(void(^)(NSArray* users, NSError* resultError))completion {
    
    NSLog(@"%s", __FUNCTION__);
    
    PFQuery *query = [PFUser query];
    if (userType != UserTypeNone) {
        [query whereKey:@"cmtUserType" equalTo:@(userType)];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSArray *users = [query findObjects:&error];
        
        if (completion) {
            completion(users, error);
        }
        
    });
    
}

- (void)signInUserWithUserEmailAddress:(NSString *)email
                         withPassword:(NSString *)userpassword
                         withUserType:(UserType)userType
                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        User *signInUser = [User user];
        //username = email と同じ!
        signInUser.username = email;
        signInUser.password = userpassword;
        signInUser.email = email;
        signInUser.cmtUserType = @(userType);
        
        NSError *resultError;
        BOOL isSucceeded = [signInUser signUp:&resultError];
        
        if (isSucceeded == YES) {
            NSLog(@"signIn Succeeded");
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                    localizedDescription:@"Create account success."];
        }else{
            NSLog(@"signIn Failed - %@", resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeSignInFailed
                                    localizedDescription:@"Create account failed."];
        }
        completion(isSucceeded, resultError);
    });
}

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
                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    if ([PFUser currentUser] == nil) {
        //logoutの場合
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        User *currentUser = [User currentUser];
        
        currentUser.cmtUserType = cmtUserType;
        currentUser.cmtWorkSchool = cmtWorkSchool;
        currentUser.cmtUserName = cmtUserName;
        currentUser.cmtFuriganaUserName = cmtFuriganaUserName;
        currentUser.cmtGender = cmtGender;
        currentUser.cmtPostalCode = cmtPostalCode;
        currentUser.cmtCellPhoneAddress = cmtCellPhoneAddress;
        currentUser.cmtPicImage = cmtPicImage;
        currentUser.cmtCheckApproval = cmtCheckApproval;
        
        NSError *resultError;
        BOOL isSucceeded = [currentUser save:&resultError];
        
        if (isSucceeded == YES) {
            NSLog(@"User detail Info Edit Succeeded - %@", resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                          localizedDescription:@"상세 정보 수정 완료"];
        }else{
            NSLog(@"can't that- %@", resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeSetDetailInfoFailed
                                          localizedDescription:@"상세 정보 수정 실패"];
        }
        completion(isSucceeded, resultError);
    });
}

/*!
 
 @abstract ログイン
 
 */
- (void)loginWithUserEmailAddress:(NSString *)email
                     withPassword:(NSString *)userpassword
                   withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* resultError;
        BOOL isSucceeded = [User logInWithUsername:email password:userpassword error:&resultError];
        if (isSucceeded == YES) {
            NSLog(@"login Succeeded");
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                    localizedDescription:@"login success."];
        }else{
            NSLog(@"can't that- %@", resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeLoginFailed
                                    localizedDescription:@"login failed."];
        }
        completion(isSucceeded, resultError);
    });
}

- (void)logoutCurrentUserWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
        [User logOutInBackgroundWithBlock:^(NSError *error){
        if (!error) {
            NSLog(@"logout Succeeded");
            error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                           localizedDescription:@"logout success."];
            if (completion) {
                completion(YES, error);
            }

        }else{
            NSLog(@"logout error %@", error);
            error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeLogoutFailed
                                           localizedDescription:@"logout failed."];
            
            if (completion) {
                completion(NO, error);
            }
        }
    }];
}

/*!
 
 @abstract 비밀번호 리셋 기능
 
 */
- (void)currentUserPasswordResetWithUserEmailAddress:(NSString *)email
                                      withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *resultError;
        BOOL isSucceeded = [User requestPasswordResetForEmail:email error:&resultError];
        if (isSucceeded == YES) {
            NSLog(@"reset Succeeded");
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                    localizedDescription:@"비밀번호 리셋 성공"];
        }else{
            NSLog(@"can't that- %@", resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodePasswordResetFailed
                                    localizedDescription:@"비밀번호 리셋 성공"];
        }
        completion(isSucceeded, resultError);
    });
}

/*!
 
 @abstract 선생 근무시작/근무종료시간 설정기능
 
 */
//+(void)setTeacherStartDate:(NSDate *)cmtStartDate withEndDate:(NSDate *)cmtEndDate{}

@end

/*
 롤 추가시 유의점(내부적으로)
 어떤 롤이든 처음 생성할 때 반드시 acl을 지정해야 한다.
 acl은 절대로 빈 값을 넣을 수 없다.
 그러므로 기본적으로 특정 보육원에 대한 롤을 생성시, acl설정은 학원롤 / 전체유저 읽기롤을 제외하고는 
 해당 보육원의 원장 유저를 읽기/쓰기 acl로 먼저 추가 후 롤 생성할 필요가 있다.
 그 후, 해당 롤 생성이 완료된 시점에서 바로 그 롤을 acl로 추가함으로 롤 추가시 acl설정은 완료된다.
 
 임시롤의 경우는 
 원장 유저 읽기/쓰기 acl + 특정유저 읽기전용 acl을 추가하기로 원장유저가 글을 삭제하고
 특정유저만 읽을 수 있게 된다.
 */

#pragma mark - Role Category
@implementation CMTParseManager (Role)

- (NSString *)schoolRoleName:(School *)school prefix:(NSString *)prefix {
    
    return [NSString stringWithFormat:@"%@_%@",prefix, school.objectId];
}

/*!
 * 학원과 같이 롤을 생성한다.
 * 원장 Role.
 * 선생님 Role.(선생님은 원장유저를 상속받는다)
 * 학부모 Role.
 * 멤버 전체 Role.(학부모, 선생님유저를 상속받는다)
 * 설명:
 * 본인이 작성한 글에 대해서는 Role과 관계없이 ACL에 의해 읽기, 쓰기가 가능하다. 그러므로,
 * 원장은 읽기,쓰기 권한을, 그리고 선생님과 학부모는 읽기권한만 주기로 하자.
 *
 * 단, 비공개 글쓰기는 위에 권한구분과 별도로 그때마다 권한을 생성하기로 한다.(아니면.. 이건 권한이아닌 코드로 제어하는게 나을지도....)
 *
 */
- (void)createSchoolRole:(School *)school completion:(void(^)(BOOL succeeded, NSError* resultError))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Role重複チェック
        PFQuery *query = [Role query];
        [query whereKey:@"cmtSchool" equalTo:school];
        NSError *is_exist_error = nil;
        NSArray *objects = [query findObjects:&is_exist_error];
        if (objects != nil && objects.count > 1) {
            //すでに作成されている。
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO,[NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                                  localizedDescription:@"이미 롤이 존재합니다"]);
                }
                return;
            });
            
        }
        
        //ロール生成
        BOOL role_succeeded = NO;
        NSError *role_error = nil;
        
        //園長ロール生成
        Role *head_teacher_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameHeadTeacher]
                                                  acl:[CMTParseManager getReadWriteACLWithUser:[User currentUser]]];
        
        //Add extra data
        head_teacher_role.cmtSchool = school;
        [head_teacher_role.users addObject:[User currentUser]];
        
        role_succeeded = [head_teacher_role save:&role_error];
        
        if(role_succeeded == NO) {
            NSLog(@"%s - create head teatcher role failed.", __PRETTY_FUNCTION__ );
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                completion(role_succeeded,
                           [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."]);
                }
                return;
            });
            
        }
        
        //先生ロール生成
        Role *teacher_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameTeacher]
                                             acl:[CMTParseManager getReadWriteACLWithUser:[User currentUser]]];
        
        //Add extra data
        teacher_role.cmtSchool = school;
        [teacher_role.roles addObject:head_teacher_role];
        
        role_succeeded = [teacher_role save:&role_error];
        
        if(role_succeeded == NO) {
            NSLog(@"%s - create teacher role failed.", __PRETTY_FUNCTION__ );
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(role_succeeded,
                               [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."]);
                }
                return;
            });
            
        }
        
        //保護者ロール生成
        Role *parents_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameParents]
                                            acl:[CMTParseManager getReadWriteACLWithUser:[User currentUser]]];
        
        //Add extra data
        parents_role.cmtSchool = school;
        
        role_succeeded = [parents_role save:&role_error];
        
        if(role_succeeded == NO) {
            NSLog(@"%s - create parents role failed.", __PRETTY_FUNCTION__ );
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(role_succeeded,
                               [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."]);
                }
                return;
            });
            
        }
        
        //全てのメンバーロール
        Role *member_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameMember]
                                           acl:[CMTParseManager getReadWriteACLWithUser:[User currentUser]]];
        
        [member_role.roles addObject:parents_role];
        [member_role.roles addObject:teacher_role];
        
        //Add extra data
        member_role.cmtSchool = school;
        
        role_succeeded = [member_role save:&role_error];
        
        if(role_succeeded == NO) {
            NSLog(@"%s - create member role failed.", __PRETTY_FUNCTION__ );
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(role_succeeded,
                               [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."]);
                }
                return;
            });
        }
        
        //全て作成できたら完了
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(YES, nil);
            }
        });
        
    });
}




















#if 0
+(void)createDefaultUserReadOnlyRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNameDefaultUserReadOnly];
        NSError *resultError;
        BOOL isSucceeded;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            Role *newRole = [Role roleWithName:kCMTRoleNameDefaultUserReadOnly
                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
            isSucceeded = [newRole save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                [newRole setACL:[self getReadOnlyACLWithRoleName:kCMTRoleNameDefaultUserReadOnly]];
                isSucceeded = [newRole save:&resultError];
                
                if (isSucceeded == YES) {
                    NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                            localizedDescription:@"롤 생성 완료 & ACL수정 완료"];
                }else{
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                            localizedDescription:@"롤 생성 완료 & ACL수정 실패"];
                    NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                }
                
            }else{
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                        localizedDescription:@"롤 생성 실패"];
                NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
            }
            
        }else{
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                    localizedDescription:@"이미 롤이 존재합니다"];
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
        }
        completion(isSucceeded, resultError);
        
    });
}

+(void)createTeacherReadOnlyRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNameTeacherReadOnly];
        NSError *resultError;
        BOOL isSucceeded;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            Role *newRole = [Role roleWithName:kCMTRoleNameTeacherReadOnly
                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
            
            isSucceeded = [newRole save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                [newRole setACL:[self getReadOnlyACLWithRoleName:kCMTRoleNameTeacherReadOnly]];
                isSucceeded = [newRole save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 완료"];
                }else{
                    NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 실패"];;
                }
            }else{
                NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                              localizedDescription:@"롤 생성 실패"];
            }
        }else{
            
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                          localizedDescription:@"이미 롤이 존재합니다"];
        }
        completion(isSucceeded, resultError);
    });
}

+(void)createTeacherRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNameTeacher];
        NSError *resultError;
        BOOL isSucceeded;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            Role *newRole = [Role roleWithName:kCMTRoleNameTeacher
                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
            isSucceeded = [newRole save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"롤 생성 완료"];
                [newRole setACL:[self getReadOnlyACLWithRoleName:kCMTRoleNameTeacher]];
                
                isSucceeded = [newRole save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 완료"];
                }else{
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 실패"];
                    NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                }
                
            }else{
                NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                              localizedDescription:@"롤 생성 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                          localizedDescription:@"이미 롤이 존재합니다"];
        }
        completion(isSucceeded, resultError);
    });
}

+(void)createMasterTeacherRoleWithCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNameMasterTeacher];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            Role *newRole = [Role roleWithName:kCMTRoleNameMasterTeacher
                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
            isSucceeded = [newRole save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                [newRole setACL:[self getReadOnlyACLWithRoleName:kCMTRoleNameMasterTeacher]];
                isSucceeded = [newRole save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 완료"];
                }else{
                    NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 실패"];
                }
            }else{
                NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                              localizedDescription:@"롤 생성 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                          localizedDescription:@"이미 롤이 존재합니다"];
        }
        completion(isSucceeded, resultError);
    });
    
}

+(void)createSelectUserReadOnlyRoleWithUsers:(NSArray *)usersArray
                              withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //현재날짜/시각으로 임시롤 생성
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd/HH:mm:ss.SSS"];
        NSDate *date = [NSDate date];
        NSString *stringDate = [dateFormatter stringFromDate:date];
        
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:stringDate];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            Role *newRole = [Role roleWithName:stringDate
                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
            for (User *user in usersArray) {
                [newRole.users addObject:user];
            }
            
            isSucceeded = [newRole save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                [newRole setACL:[self getReadOnlyACLWithRoleName:stringDate]];
                isSucceeded = [newRole save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 완료"];
                }else{
                    NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                  localizedDescription:@"롤 생성 완료 & ACL수정 실패"];
                }
                
            }else{
                NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                              localizedDescription:@"롤 생성 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                          localizedDescription:@"이미 롤이 존재합니다"];
        }
        completion(isSucceeded, resultError);
    
    });
}

+(void)createSchoolRoleWithRoleName:(NSString*)roleName
                          withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:roleName];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count == 0) {
            //학원 롤 생성전 해당 학원에 포함될 자식롤 검색
            PFQuery *otherRoleSearchQuery = [Role query];
            NSArray *otherRoleNames = @[kCMTRoleNameTeacher, kCMTRoleNameTeacherReadOnly, kCMTRoleNameMasterTeacher, kCMTRoleNameDefaultUserReadOnly];
            [otherRoleSearchQuery whereKey:@"name" containedIn:otherRoleNames];
            NSArray *objects = [otherRoleSearchQuery findObjects:&resultError];
            if (objects.count == 4) {
                //검색결과에 해당하는 롤들만 자식롤에 넣는다.
                Role *newRole = [Role roleWithName:roleName
                                               acl:[self getReadWriteACLWithUser:[User currentUser]]];
                for (Role *childRole in objects) {
                    [newRole.roles addObject:childRole];
                }
                isSucceeded = [newRole save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - create success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                  localizedDescription:@"롤 생성 완료"];
                    [newRole setACL:[self getReadOnlyACLWithRoleName:roleName]];
                    isSucceeded = [newRole save:&resultError];
                    if (isSucceeded == YES) {
                        NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
                        resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                      localizedDescription:@"ACL수정 완료"];
                    }else{
                        NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,resultError);
                        resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                      localizedDescription:@"ACL수정 실패"];
                    }
                }else{
                    NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,resultError);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
                                                  localizedDescription:@"롤 생성 실패"];
                }
            }else{
                NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                              localizedDescription:@"필요한 롤의 갯수가 부족합니다"];
                for (int i = 0; i >= (objects.count - 1); i++) {
                    Role *transaction = (Role*)[objects objectAtIndex:i];;
                    BOOL isTransactionSucceeded = [transaction delete:&resultError];
                    if (isTransactionSucceeded == YES) {
                        NSLog(@"transaction Succeeded - %@", [objects objectAtIndex:i]);
                    }else{
                        NSLog(@"transaction Failed - %@", [objects objectAtIndex:i]);
                    }
                }
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                          localizedDescription:@"이미 롤이 존재합니다"];
        }
        
        completion(isSucceeded, resultError);
    
    });
}

//퍼블릭롤은...서버상에서 관리하고 유저 추가만 하는게 좋을거같음;;
//+(void)createPublicUserReadOnlyRoleWithError:(NSError **)resultError{
//    PFQuery *query = [Role query];
//    [query whereKey:@"name" equalTo:kCMTRoleNamePublicUserReadOnly];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error) {
//        if (object.count == 0) {
//            Role *newRole = [Role roleWithName:kCMTRoleNamePublicUserReadOnly
//                                           acl:[self getReadWriteACLWithUser:[User currentUser]]];
//            [newRole saveInBackgroundWithBlock:^(BOOL success, NSError *error){
//                if (success) {
//                    NSLog(@"%s - create success", __PRETTY_FUNCTION__);
//                    *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
//                                                   localizedDescription:@"롤 생성 완료"];
//                    [newRole setACL:[self getReadOnlyACLWithRoleName:kCMTRoleNamePublicUserReadOnly]];
//                    [newRole saveInBackgroundWithBlock:^(BOOL success, NSError *error){
//                        if (success) {
//                            NSLog(@"%s - acl success", __PRETTY_FUNCTION__);
//                            *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
//                                                           localizedDescription:@"ACL수정 완료"];
//                        }else{
//                            *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
//                                                           localizedDescription:@"ACL수정 실패"];
//                            NSLog(@"%s - acl failed : %@", __PRETTY_FUNCTION__ ,error);
//                        }
//                    }];
//
//                }else{
//                    *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorOther
//                                                   localizedDescription:@"롤 생성 실패"];
//                    NSLog(@"%s - create failed : %@", __PRETTY_FUNCTION__ ,error);
//                }
//            }];
//        }else{
//            *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
//                                           localizedDescription:@"이미 롤이 존재합니다"];
//            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,error);
//        }
//    }];
//}



#pragma mark - Add User
/*!
 
 @abstract 일반유저(읽기전용)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addDefaultUserReadOnlyRoleUsersWithUserInformation:(User *)user
                                           withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFQuery *query = [Role query];
        
        [query whereKey:@"name" equalTo:kCMTRoleNameDefaultUserReadOnly];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count != 0) {
            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
            PFObject *resultObject = [object objectAtIndex:0];
            Role *role = (Role *)resultObject;
            [role.users addObject:user];
            isSucceeded = [role save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - add success", __PRETTY_FUNCTION__);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"유저 추가 성공"];
            }else{
                NSLog(@"add failed%@", resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
                                              localizedDescription:@"유저 추가 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                          localizedDescription:@"롤이 존재하지 않습니다"];
        }
        completion(isSucceeded, resultError);
        
    });
}

/*!
 
 @abstract 선생유저(읽기전용)롤에 유저 추가 기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addTeacherReadOnlyRoleUsersWithUserInformation:(User *)user
                                       withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *query = [Role query];
        
        [query whereKey:@"name" equalTo:kCMTRoleNameTeacherReadOnly];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray * object = [query findObjects:&resultError];
        if (object.count != 0) {
            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
            PFObject *resultObject = [object objectAtIndex:0];
            Role *role = (Role *)resultObject;
            [role.users addObject:user];
            isSucceeded = [role save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - add success", __PRETTY_FUNCTION__);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"유저 추가 성공"];
            }else{
                NSLog(@"add failed%@", resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
                                              localizedDescription:@"유저 추가 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                          localizedDescription:@"롤이 존재하지 않습니다"];
        }
        completion(isSucceeded, resultError);
        
    });
}

/*!
 
 @abstract 선생유저(읽기,쓰기)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addTeacherRoleUsersWithUserInformation:(User *)user
                               withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *query = [Role query];
        
        [query whereKey:@"name" equalTo:kCMTRoleNameTeacher];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count != 0) {
            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
            PFObject *resultObject = [object objectAtIndex:0];
            Role *role = (Role *)resultObject;
            [role.users addObject:user];
            isSucceeded = [role save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - add success", __PRETTY_FUNCTION__);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"유저 추가 성공"];
            }else{
                NSLog(@"add failed%@", resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
                                              localizedDescription:@"유저 추가 실패"];
            }
            
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                          localizedDescription:@"롤이 존재하지 않습니다"];
        }
        completion(isSucceeded, resultError);
    
    });
}

/*!
 
 @abstract 원장유저(읽기,쓰기)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addMasterTeacherRoleUsersWithUserInformation:(User *)user
                                          withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNameMasterTeacher];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count != 0) {
            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
            PFObject *resultObject = [object objectAtIndex:0];
            Role *role = (Role *)resultObject;
            [role.users addObject:user];
            isSucceeded = [role save:&resultError];
            if (isSucceeded == YES) {
                NSLog(@"%s - add success", __PRETTY_FUNCTION__);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"유저 추가 성공"];
            }else{
                NSLog(@"add failed%@", resultError);
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
                                              localizedDescription:@"유저 추가 실패"];
            }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                          localizedDescription:@"롤이 존재하지 않습니다"];
        }
        completion(isSucceeded, resultError);
    });
}

/*
 미완성, const값을 동적으로 지정 하는법을 잘 몰라서...
 */
//+(void)addSchoolRoleUsersWithUserInformation:(User *)user
//                                   withError:(NSError **)resultError{
//    PFQuery *query = [Role query];
//    
//    [query whereKey:@"name" equalTo:<#Rolename#>];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error){
//        if (object.count != 0) {
//            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
//            PFObject *resultObject = [object objectAtIndex:0];
//            Role *role = (Role *)resultObject;
//            [role.users addObject:user];
//            [role saveInBackgroundWithBlock:^(BOOL success, NSError *error){
//                if (success) {
//                    NSLog(@"%s - add success", __PRETTY_FUNCTION__);
//                    *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
//                                                   localizedDescription:@"유저 추가 성공"];
//                }else{
//                    NSLog(@"add failed%@", resultError);
//                    *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
//                                                   localizedDescription:@"유저 추가 실패"];
//                }
//            }];
//        }else{
//            *resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
//                                           localizedDescription:@"롤이 존재하지 않습니다"];
//            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,error);
//        }
//    }];
//}

/*
 Public이니...그냥 전체유저 쿼리를 돌려서 다 추가하는걸로?
 */

/*!
 
 @abstract 전체유저(읽기전용)롤에 유저 추가기능(원장 아이디로만 롤에 유저 추가가능)
 
 */
+(void)addPublicUserReadOnlyRoleUsersWithUserInformation:(User *)user
                                          withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *query = [Role query];
        [query whereKey:@"name" equalTo:kCMTRoleNamePublicUserReadOnly];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *object = [query findObjects:&resultError];
        if (object.count != 0) {
            NSLog(@"%s - find success", __PRETTY_FUNCTION__);
            PFObject *resultObject = [object objectAtIndex:0];
            Role *role = (Role *)resultObject;
            [role.users addObject:user];
            [role save:&resultError];
                if (isSucceeded == YES) {
                    NSLog(@"%s - add success", __PRETTY_FUNCTION__);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                                   localizedDescription:@"유저 추가 성공"];
                }else{
                    NSLog(@"add failed%@", resultError);
                    resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeUserAddFailed
                                                   localizedDescription:@"유저 추가 실패"];
                }
        }else{
            NSLog(@"%s - failed : %@", __PRETTY_FUNCTION__ ,resultError);
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                           localizedDescription:@"롤이 존재하지 않습니다"];
        }
    });
}

#pragma mark - Remove Role
//삭제는 가능하나 로그인한 유저와 관계있는 롤만 삭제가능함...
/*!
 
 @abstract 로그인 유저에 쓰기권한을 가진경우 롤 삭제기능
 
 */
+(void)removeRoleWithRoleName:(NSString *)roleName
                    withCompletion:(void(^)(BOOL isSucceeded, NSError* resultError))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PFQuery *roleSearchQuery = [Role query];
        [roleSearchQuery whereKey:@"name" equalTo:roleName];
        BOOL isSucceeded;
        NSError *resultError;
        NSArray *resultObjects = [roleSearchQuery findObjects:&resultError];
        //    [roleSearchQuery whereKeyExists:@"name"];
        if (resultObjects.count != 0) {
            Role *deleteRole = (Role *)resultObjects.firstObject;
            isSucceeded = [deleteRole delete:&resultError];
            if (isSucceeded == YES) {
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNone
                                              localizedDescription:@"롤 삭제 성공"];
                NSLog(@"objectDelete Succeed");
            }else{
                resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeRoleDeleteFailed
                                              localizedDescription:@"롤 삭제 실패"];
                NSLog(@"objectDelete Failed");
            }
        }else{
            resultError = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData
                                          localizedDescription:@"롤이 존재하지 않습니다"];
            NSLog(@"object not found");
        }
     
    });
}

#pragma mark - Test API'S
/*!
 
 @abstract 테스트용 api - 유저네임으로 유저 오브젝트 검색기능
 
 */
+(User*)getUserObjectWithUserName:(NSString*)userName{
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:userName];
    NSError *resultError;
    NSArray *object = [query findObjects:&resultError];
    User *resultUser = (User*)object.firstObject;
    
    return resultUser;
}
#endif
@end
