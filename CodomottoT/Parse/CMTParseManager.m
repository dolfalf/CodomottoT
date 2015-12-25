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
@dynamic currentUser;
@dynamic currentSchool;

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

#pragma mark getter
- (BOOL)isLogin {
    
    return ([User currentUser]==nil)?NO:YES;
}

- (UserType)userType {
    
    if ([User currentUser] == nil) {
        return UserTypeNone;
    }
    
    return (UserType)[[User currentUser].cmtUserType integerValue];
}

- (User *)currentUser {
    return [User currentUser];
}

- (School *)currentSchool {
    return [User currentUser].cmtWorkSchool;
}

@end

#pragma mark - ACL Category
@implementation CMTParseManager (ACL)

- (PFACL *)publicReadOnlyACL {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:NO];
    
    return acl;
}

- (PFACL *)publicReadWriteACL {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setPublicReadAccess:YES];
    [acl setPublicWriteAccess:YES];
    
    return acl;
}

- (PFACL *)roleReadOnlyACL:(NSString *)roleName {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:NO forRoleWithName:roleName];
    
    return acl;
}

- (PFACL *)roleReadWriteACL:(NSString *)roleName {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:YES forRoleWithName:roleName];
    
    return acl;
}

- (PFACL *)publicReadOnlyACLWithReadWriteRole:(NSString *)roleName {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:YES forRoleWithName:roleName];
    
    [acl setPublicReadAccess:YES];
    
    return acl;
}

- (PFACL *)publicReadOnlyACLWithReadOnlyRole:(NSString *)roleName {
    
    PFACL *acl = [PFACL ACL];
    [acl setWriteAccess:YES forUser:[User currentUser]];
    [acl setReadAccess:YES forUser:[User currentUser]];
    
    [acl setReadAccess:YES forRoleWithName:roleName];
    [acl setWriteAccess:NO forRoleWithName:roleName];
    
    [acl setPublicReadAccess:YES];
    
    return acl;
}

@end

#pragma mark - User Category
@implementation CMTParseManager (User)

- (void)registUserSchool:(School *)school {
    NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *err = nil;
        [User currentUser].cmtWorkSchool = school;
        [[User currentUser] save:&err];
    });
    
}

- (void)fetchUsers:(UserType)userType block:(void(^)(NSArray* users, NSError* error))block {
    
    NSLog(@"%s", __FUNCTION__);
    
    PFQuery *query = [PFUser query];
    if (userType != UserTypeNone) {
        [query whereKey:@"cmtUserType" equalTo:@(userType)];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *err = nil;
        NSArray *users = [query findObjects:&err];
        
        if (block) {
            block(users,err);
        }
        
    });
    
}

- (void)signUp:(NSString *)email password:(NSString *)password userType:(UserType)utype block:(void (^)(NSError *))block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        User *signInUser = [User user];
        //username = email と同じ!
        signInUser.username = email;
        signInUser.password = password;
        signInUser.email = email;
        signInUser.cmtUserType = @(utype);
        
        NSError *error = nil;
        BOOL isSucceeded = [signInUser signUp:&error];
        
        if (isSucceeded == YES) {
            NSLog(@"signUp Succeeded");
        }else{
            NSLog(@"signUp Failed - %@", error);
            error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeSignInFailed
                                    localizedDescription:@"Create account failed."];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
        
    });
}

/*!
 
 @abstract ログイン
 
 */
- (void)signIn:(NSString *)email password:(NSString *)password block:(errorBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        BOOL isSucceeded = [User logInWithUsername:email password:password error:&error];
        if (isSucceeded == YES) {
            NSLog(@"login Succeeded");
        }else{
            NSLog(@"can't that- %@", error);
            error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeLoginFailed
                                    localizedDescription:@"login failed."];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
        
    });
}

- (void)signOut {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [User logOut];
    });
}

/*!
 @abstract 비밀번호 리셋 기능
 */
- (void)resetPassword:(NSString *)email block:(errorBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        BOOL isSucceeded = [User requestPasswordResetForEmail:email error:&error];
        
        if (isSucceeded == YES) {
            NSLog(@"reset Succeeded");
        }else{
            NSLog(@"can't that- %@", error);
            error = [NSError errorWithCodomottoErrorCode:CMTErrorCodePasswordResetFailed
                                    localizedDescription:@"비밀번호 리셋 에러"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
        
    });
}

@end

#pragma mark - Role Category
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

@implementation CMTParseManager (Role)

- (NSString *)schoolRoleName:(School *)school prefix:(NSString *)prefix {
    
    return [NSString stringWithFormat:@"%@_%@",prefix, school.objectId];
}

- (void)hasAccessRoleToSchoolInBackground:(boolBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL hasAccess = [self hasAccessRoleToSchool];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(hasAccess);
            }
        });
        
    });
}

- (BOOL)hasAccessRoleToSchool {
    
    NSLog(@"%s", __FUNCTION__);
    
    if (self.currentSchool == nil) {
        return NO;
    }
    
    PFQuery *role_query = [PFRole query];
    
    [role_query whereKey:@"cmtSchool" equalTo:self.currentSchool];
    
    NSArray *school_roles = [role_query findObjects];
    
    for (PFRole *s_role in school_roles) {
        
        NSArray *school_users = [[s_role.users query] findObjects];
        
        for (User *s_user in school_users) {
            if ([s_user isEqual:self.currentUser]) {
                //Allowed
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)createRoleForSchoolInBackground:school block:(errorBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        [self createRoleForSchool:school error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        });
    });
}

/*!
 * 園とともに必要なロールを生成する。
 * 全てのロールはPublicReadOnlyを設定する。
 * 園長は全てのロールに対してReadWrite権限を設定する。
 * 先生ロールは園長ロールから継承する。
 * 保護者ロールはロール継承なし。
 * メンバー全体ロールはロール継承なし。（ロールのユーザーリストには全ての園メンバーを追加する）
 */
- (BOOL)createRoleForSchool:(School *)school error:(NSError **)error {
    
    //Role重複チェック
    PFQuery *query = [Role query];
    [query whereKey:@"cmtSchool" equalTo:school];
    NSError *is_exist_error = nil;
    NSArray *objects = [query findObjects:&is_exist_error];
    if (objects != nil && objects.count > 1) {
        //すでに作成されている。
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeAlreadyData
                                 localizedDescription:@"Already role."];
        return NO;
        
    }
    
    //ロール生成
    BOOL role_succeeded = NO;
    NSError *role_error = nil;
    
    //園長ロール生成
    NSString *head_teacher_rolename = [self schoolRoleName:school prefix:kCMTRoleNameHeadTeacher];
    
    Role *head_teacher_role = [Role roleWithName:head_teacher_rolename acl:[self publicReadOnlyACL]];
    //Add extra data
    head_teacher_role.cmtSchool = school;
    [head_teacher_role.users addObject:[User currentUser]];
    
    role_succeeded = [head_teacher_role save:&role_error];
    
    if(role_succeeded == NO) {
        NSLog(@"%s - create head teatcher role failed.", __PRETTY_FUNCTION__ );
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."];
        return NO;
    }
    
    //先生ロール生成
    Role *teacher_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameTeacher]
                                         acl:[self publicReadOnlyACLWithReadWriteRole:head_teacher_rolename]];
    
    //Add extra data
    teacher_role.cmtSchool = school;
    
    //inherit role
    [teacher_role.roles addObject:head_teacher_role];
    
    role_succeeded = [teacher_role save:&role_error];
    
    if(role_succeeded == NO) {
        NSLog(@"%s - create teacher role failed.", __PRETTY_FUNCTION__ );
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."];
        return NO;
    }
    
    //保護者ロール生成
    Role *parents_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameParents]
                                        acl:[self publicReadOnlyACLWithReadWriteRole:head_teacher_rolename]];
    
    //Add extra data
    parents_role.cmtSchool = school;
    
    role_succeeded = [parents_role save:&role_error];
    
    if(role_succeeded == NO) {
        NSLog(@"%s - create parents role failed.", __PRETTY_FUNCTION__ );
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."];
        return NO;
    }
    
    //全てのメンバーロール
    Role *member_role = [Role roleWithName:[self schoolRoleName:school prefix:kCMTRoleNameMember]
                                       acl:[self publicReadOnlyACLWithReadWriteRole:head_teacher_rolename]];
    
    //Add extra data
    member_role.cmtSchool = school;
    
    role_succeeded = [member_role save:&role_error];
    
    if(role_succeeded == NO) {
        NSLog(@"%s - create member role failed.", __PRETTY_FUNCTION__ );
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorOther localizedDescription:@"Create role failed."];
        return NO;
    }
    
    return YES;
}

- (void)addUserSchoolRoleInBackground:(RequestUser *)requestUser block:(errorBlock)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        [self addUserSchoolRole:requestUser error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(error);
            }
        });
    });
}

/*!
 * リクエストユーザーをロールに追加する
 * リクエストしたユーザーの属性(UserType)を確認し、該当ロールに追加する
 */
- (BOOL)addUserSchoolRole:(RequestUser *)ruser error:(NSError **)error {
    
    //Role検索
    PFQuery *role_query = [PFRole query];
    [role_query whereKey:@"cmtSchool" equalTo:ruser.registSchool];
    
    NSError *is_exist_error = nil;
    NSArray *roles = [role_query findObjects:&is_exist_error];
    if (roles == nil || roles.count == 0) {
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"no roles"];
        return NO;
    }
    
    PFQuery *user_query = [PFUser query];
    [user_query whereKey:@"objectId" equalTo:ruser.requestUser.objectId];
    
    NSArray *users = [user_query findObjects:&is_exist_error];
    if (users == nil || users.count == 0) {
        *error = [NSError errorWithCodomottoErrorCode:CMTErrorCodeNoData localizedDescription:@"no users"];
        return NO;
    }
    
    
    UserType request_user_type = (UserType)[((User *)users.firstObject).cmtUserType integerValue];
    NSString *user_type_key =
    request_user_type == UserTypeHeadTeacher?kCMTRoleNameHeadTeacher:
    request_user_type == UserTypeTeacher?kCMTRoleNameTeacher:
    request_user_type == UserTypeParents?kCMTRoleNameParents:nil;
    
    
    for (Role *s_role in roles) {
        
        //該当ロールに追加
        if ([s_role.name hasPrefix:user_type_key]) {
            [s_role.users addObject:ruser.requestUser];
            [s_role save];
            continue;
        }
        
        //園メンバー全員ロールに追加
        if ([s_role.name hasPrefix:kCMTRoleNameMember]) {
            [s_role.users addObject:ruser.requestUser];
            [s_role save];
            continue;
        }
    }
    
    return YES;
}

/*!
 * まだ検証してない
 @abstract 로그인 유저에 쓰기권한을 가진경우 롤 삭제기능
 */
- (void)removeSchoolRole:(School *)school block:(errorBlock)block {
    
#if 0
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
    
#endif
    
}

@end
