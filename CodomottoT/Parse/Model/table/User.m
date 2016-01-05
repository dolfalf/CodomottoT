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
@dynamic cmtChilds;
@dynamic cmtDeleteFlag;
@dynamic ACL;

+ (void)load {
    [self registerSubclass];
}

@end
