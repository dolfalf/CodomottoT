//
//  ParseModel.h
//  Codomotto
//
//  Created by kjcode on 2015/03/06.
//  Copyright (c) 2015年 kjcode. All rights reserved.
//

#ifndef ParseModel_const_h
#define ParseModel_const_h

#import <Parse/Parse.h>

//add sample
#import "sampleModel.h"
#import "sampleDetailModel.h"

#import "User.h"
#import "Role.h"
#import "Contact.h"
#import "ContactComment.h"
#import "ContactPhoto.h"
#import "ContactRead.h"

#import "School.h"
#import "Group.h"

typedef NS_ENUM(NSInteger, CMTErrorCode) {
    /*!
     @abstract 에러코드
     @param 0 = 에러없음
     @param 1 = 동일 데이터 존재
     @param 2 = 동일 데이터 없음
     @param 3 = 유저 추가 실패
     @param 4 = 롤 삭제 실패
     @param 5 = 어카운트 생성 실패
     @param 6 = 로그인 실패
     @param 7 = 유저 상세 데이터 입력 실패
     @param 8 = 로그아웃 실패
     @param 9 = 비밀번호 리셋 실패
     @param 100 = 기타 에러
     */
    CMTErrorCodeNone = 0,
    CMTErrorCodeAlreadyData = 1,
    CMTErrorCodeNoData = 2,
    CMTErrorCodeUserAddFailed = 3,
    CMTErrorCodeRoleDeleteFailed = 4,
    CMTErrorCodeSignInFailed = 5,
    CMTErrorCodeLoginFailed = 6,
    CMTErrorCodeSetDetailInfoFailed = 7,
    CMTErrorCodeLogoutFailed = 8,
    CMTErrorCodePasswordResetFailed = 9,
    CMTErrorOther = 100,
};
#endif