//
//  User.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "User.h"
#import "School.h"

@implementation User

//  objectId (auto)
@dynamic username;
@dynamic password;
//  authData (unknown...authData는 어디에서?)
@dynamic email;
//메일 인증기능 ON시 사용하는 값이므로 필요없음
//@dynamic cmtEmailVerified;
@dynamic cmtUserName;
@dynamic cmtFuriganaUserName;
@dynamic cmtPostalCode;
@dynamic cmtCellPhoneAddress;
@dynamic cmtUserType;
@dynamic cmtWorkSchool;
@dynamic cmtGender;
@dynamic cmtPicImage;
@dynamic cmtStartDate;
@dynamic cmtEndDate;
@dynamic cmtDeleteFlag;
@dynamic cmtCheckApproval;
//기본적으로 유저 자기자신의 ACL은 읽기/쓰기가 설정되어있음(자동)
//@dynamic ACL;
//  createAt (auto)
//  updateAt (auto)

+ (void)load {
    [self registerSubclass];
}

@end
