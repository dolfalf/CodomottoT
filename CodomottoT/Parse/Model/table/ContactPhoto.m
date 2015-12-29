//
//  ContactPhoto.m
//  Codomotto
//
//  Created by kjcode on 2015/07/26.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactPhoto.h"
#import "CMTParseManager.h"

@implementation ContactPhoto

@dynamic imageName;
@dynamic imageFile;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

+ (instancetype)createModel {
    
    ContactPhoto *model = [[self alloc] init];
    
    model.ACL = [[CMTParseManager sharedInstance] postContactACL];
    
    return model;
}

@end
