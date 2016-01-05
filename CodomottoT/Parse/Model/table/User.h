//
//  User.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

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
@property (nonatomic, strong) PFRelation *cmtChilds;
@property (nonatomic, assign) BOOL cmtDeleteFlag;

@property (nonatomic, strong) PFACL *ACL;

@end
