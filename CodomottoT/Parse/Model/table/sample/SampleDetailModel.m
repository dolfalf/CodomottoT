//
//  SampleDetailModel.m
//  Codomotto
//
//  Created by kjcode on 2015/07/05.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "SampleDetailModel.h"
#import <Parse/PFObject+Subclass.h>

@implementation SampleDetailModel

@dynamic foo;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"SampleDetailModel";
}

@end
