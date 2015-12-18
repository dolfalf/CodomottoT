//
//  User.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>
#import "const.h"

@class School;
@interface User : PFUser

//  objectId (auto)
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
//  authData (unknown...authData는 어디에서?)
@property (nonatomic, strong) NSString *email;
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
//  createAt (auto)
//  updateAt (auto)

@end
