//
//  GroupEditViewController.h
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/04.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "CMTViewController.h"

typedef NS_ENUM(NSInteger, GroupEditType) {
    GroupEditTypeNew,
    GroupEditTypeModify,
};

@class Group;

@interface GroupEditViewController : CMTViewController

@property (nonatomic, assign) GroupEditType editType;
@property (nonatomic, strong) Group *group;

@end
