//
//  Role.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class School;

@interface Role : PFRole <PFSubclassing>

@property (nonatomic, strong) School *cmtSchool;
@end
