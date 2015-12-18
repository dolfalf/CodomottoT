//
//  Schedule.h
//  Codomotto
//
//  Created by kjcode on 2015/09/24.
//  Copyright © 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@interface Schedule : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, assign) BOOL alldayFlag;
@property (nonatomic, assign) NSDate *startDate;
@property (nonatomic, assign) NSDate *endDate;
@property (nonatomic, assign) BOOL repeatFlag;
@property (nonatomic, assign) BOOL notifyFlag;

@property (nonatomic, assign) BOOL noticeFlag;          //default NO.
@property (nonatomic, assign) BOOL deleteFlag;          //default NO.
@property (nonatomic, strong) PFACL *ACL;               //set Role.

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
