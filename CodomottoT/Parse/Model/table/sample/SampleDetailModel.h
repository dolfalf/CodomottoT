//
//  SampleDetailModel.h
//  Codomotto
//
//  Created by kjcode on 2015/07/05.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ParseModel.h"

@interface SampleDetailModel : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *foo;

+ (NSString *)parseClassName;
@end
