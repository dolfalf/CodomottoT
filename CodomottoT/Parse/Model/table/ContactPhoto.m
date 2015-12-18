//
//  ContactPhoto.m
//  Codomotto
//
//  Created by kjcode on 2015/07/26.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactPhoto.h"

@implementation ContactPhoto

@dynamic imageName;
@dynamic imageFile;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ContactPhoto";
}

+ (instancetype)createModel {
    
    ContactPhoto *model = [[self alloc] init];
    
    //여기서 초기화 처리를 해준다.
    //model.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    return model;
}

@end
