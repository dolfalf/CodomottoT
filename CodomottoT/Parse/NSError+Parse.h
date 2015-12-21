//
//  NSError+Parse.h
//  Codomotto
//
//  Created by Codomotto on 2015/07/28.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseModel.h"

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

@interface NSError (Parse)

#define CodomottoErrorDomain @"com.codomotto.error"

+ (NSError*)errorWithCodomottoErrorCode:(CMTErrorCode)code
                   localizedDescription:(NSString* )localizedDescription;

@end
