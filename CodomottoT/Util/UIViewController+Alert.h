//
//  UIViewController+Alert.h
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/08.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

- (void)showConfirmAlertView:(NSString *)message block:(void(^)(void))block;
@end
