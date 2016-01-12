//
//  School.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@interface School : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *address3;
@property (nonatomic, strong) NSString *kana1;
@property (nonatomic, strong) NSString *kana2;
@property (nonatomic, strong) NSString *kana3;
@property (nonatomic, strong) NSNumber *prefcode;
@property (nonatomic, strong) NSNumber *zipcode;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) BOOL deleteFlag;
@property (nonatomic, strong) PFACL *ACL;

+ (NSString *)parseClassName;
+ (instancetype)createModel;

@end
