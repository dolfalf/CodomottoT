//
//  UIColor+Helper.h
//  Codomotto
//
//  Created by Lee jaeeun on 2014/06/28.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

#pragma mark - Codomotto Theme color

/**
 * text, button text, icon
 */
+ (UIColor *)CMTNormalColor;

/**
 * header navibar,...
 */
+ (UIColor *)CMTRedColor;

+ (UIColor *)CMTWhiteColor;
+ (UIColor *)CMTButtonGrayColor;
+ (UIColor *)CMTLineGrayColor;

/**
 * sub-text, ...
 */
+ (UIColor *)CMTTextGrayColor;

#pragma mark - background color
+ (UIColor *)CMTBackgroundNormalColor;
+ (UIColor *)CMTBackgroundRedColor;
+ (UIColor *)CMTBackgroundWhiteColor;
+ (UIColor *)CMTBackgroundButtonGrayColor;
+ (UIColor *)CMTBackgroundLineGrayColor;

#pragma mark - tabbar color
+ (UIColor *)CMTTabBarColor:(UIControlState)state;

@end
