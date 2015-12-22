//
//  User.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>
#import "const.h"

typedef NS_ENUM(NSInteger, Gender) {
    GenderKnown,
    GenderMale,
    GenderFemale,
};

typedef NS_ENUM(NSInteger, UserType) {
    UserTypeNone = -1,
    UserTypeHeadTeacher = 0,
    UserTypeTeacher,
    UserTypeParents,
};

@class School;
@interface User : PFUser <PFSubclassing>

//메일 인증기능 ON시 사용하는 값이므로 필요없음
//@property (nonatomic, assign) BOOL cmtEmailVerified;

@property (nonatomic, strong) NSString* cmtUserName;
@property (nonatomic, strong) NSString* cmtFuriganaUserName;
@property (nonatomic, strong) NSString* cmtPostalCode;
@property (nonatomic, strong) NSString* cmtCellPhoneAddress;
@property (nonatomic, strong) NSNumber *cmtUserType;
@property (nonatomic, strong) School *cmtWorkSchool;
@property (nonatomic, strong) NSNumber* cmtGender;
@property (nonatomic, strong) NSData *cmtPicImage;
@property (nonatomic, strong) NSDate *cmtStartDate;
@property (nonatomic, strong) NSDate *cmtEndDate;
@property (nonatomic, assign) BOOL cmtDeleteFlag;
@property (nonatomic, strong) NSNumber *cmtCheckApproval;

//기본적으로 유저 자기자신의 ACL은 읽기/쓰기가 설정되어있음(자동)
//@property (nonatomic, strong) PFACL *ACL;

@end
