//
//  SampleModel.m
//  Codomotto
//
//  Created by kjcode on 2015/07/05.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "SampleModel.h"
#import <Parse/PFObject+Subclass.h>

@implementation SampleModel

@dynamic hoge;
@dynamic huga;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"SampleModel";
}

@end
