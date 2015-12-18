//
//  ContactPhoto.h
//  Codomotto
//
//  Created by kjcode on 2015/07/26.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@interface ContactPhoto : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) PFFile *imageFile;

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
