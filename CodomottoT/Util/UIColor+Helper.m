//
//  UIColor+Helper.m
//  Codomotto
//
//  Created by Lee jaeeun on 2014/06/28.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "UIColor+Helper.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

/*
 
 Normal (67,38,33)
 Red (238,0,17)
 White (253,253,239) - spot
 Button_Grey (218,213,201) - selected
 Line_Grey (236,233,220) - reserved
 Text_Grey (176, 168, 158)
 
 BGNormal (67,38,33)
 BGRed (238,0,17)
 BGWhite (253,253,239) - 생략시 지정
 BGButton_Grey (218,213,201)
 BGLine_Grey (236,233,220)
 
 */

@implementation UIColor (Helper)

+ (id)colorWithHexString:(NSString *)hex alpha:(CGFloat)a
{
    
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    if (![colorScanner scanHexInt:&color]) return nil;
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

#pragma mark - Codomotto Theme color
+ (UIColor *)CMTNormalColor {
    return [UIColor CMTNormalColor:1.f];
}

+ (UIColor *)CMTNormalColor:(float)alpha {
    //Normal (67,38,33)
    return [UIColor colorWithHexString:@"432621" alpha:alpha];
}

+ (UIColor *)CMTRedColor {
    return [UIColor CMTRedColor:1.f];
}

+ (UIColor *)CMTRedColor:(float)alpha {
    //Red (238,0,17)
    return [UIColor colorWithHexString:@"ee0011" alpha:alpha];
}

+ (UIColor *)CMTWhiteColor {
    return [UIColor CMTWhiteColor:1.f];
}

+ (UIColor *)CMTWhiteColor:(float)alpha {
    // White (253,253,239) - spot
    return [UIColor colorWithHexString:@"fdfdef" alpha:alpha];
}

+ (UIColor *)CMTButtonGrayColor {
    return [UIColor CMTButtonGrayColor:1.f];
}

+ (UIColor *)CMTButtonGrayColor:(float)alpha {
    //Button_Grey (218,213,201) - selected
    return [UIColor colorWithHexString:@"dad5c9" alpha:alpha];
}

+ (UIColor *)CMTLineGrayColor {
    return [UIColor CMTLineGrayColor:1.f];
}

+ (UIColor *)CMTLineGrayColor:(float)alpha {
    // Line_Grey (236,233,220) - reserved
    return [UIColor colorWithHexString:@"ece9dc" alpha:alpha];
}

+ (UIColor *)CMTTextGrayColor {
    return [UIColor CMTTextGrayColor:1.f];
}

+ (UIColor *)CMTTextGrayColor:(float)alpha {
    // Text_Grey (176, 168, 158)
    return [UIColor colorWithHexString:@"b0a89e" alpha:alpha];
}

#pragma mark - background color
+ (UIColor *)CMTBackgroundNormalColor {
    return [UIColor CMTBackgroundNormalColor:1.f];
}

+ (UIColor *)CMTBackgroundNormalColor:(float)alpha {
    //BGNormal (67,38,33)
    return [UIColor colorWithHexString:@"432621" alpha:alpha];
}

+ (UIColor *)CMTBackgroundRedColor {
    return [UIColor CMTBackgroundRedColor:1.f];
}

+ (UIColor *)CMTBackgroundRedColor:(float)alpha {
    //BGRed (238,0,17)
    return [UIColor colorWithHexString:@"ee0011" alpha:alpha];
}

+ (UIColor *)CMTBackgroundWhiteColor {
    return [UIColor CMTBackgroundWhiteColor:1.f];
}

+ (UIColor *)CMTBackgroundWhiteColor:(float)alpha {
    //BGWhite (253,253,239) - 생략시 지정
    return [UIColor colorWithHexString:@"fdfdef" alpha:alpha];
}

+ (UIColor *)CMTBackgroundButtonGrayColor {
    return [UIColor CMTBackgroundButtonGrayColor:1.f];
}

+ (UIColor *)CMTBackgroundButtonGrayColor:(float)alpha {
    // BGButton_Grey (218,213,201)
    return [UIColor colorWithHexString:@"dad5c9" alpha:alpha];
}

+ (UIColor *)CMTBackgroundLineGrayColor {
    return [UIColor CMTBackgroundLineGrayColor:1.f];
}

+ (UIColor *)CMTBackgroundLineGrayColor:(float)alpha {
    // BGLine_Grey (236,233,220)
    return [UIColor colorWithHexString:@"ece9dc" alpha:alpha];
}

#pragma mark - tabbar color
+ (UIColor *)CMTTabBarColor:(UIControlState)state {
    
    if (state == UIControlStateNormal) {
        return [UIColor colorWithRed:236/255.f green:233/255.f blue:220/255.f alpha:1];
    }else if((state & UIControlStateHighlighted) == UIControlStateHighlighted) {
        return [UIColor colorWithRed:194/255.f green:187/255.f blue:176/255.f alpha:1];
    }else if((state & UIControlStateSelected) == UIControlStateSelected) {
        return [UIColor colorWithRed:218/255.f green:213/255.f blue:201/255.f alpha:1];
    }
    
    //normal color
    return [UIColor colorWithRed:236/255.f green:233/255.f blue:220/255.f alpha:1];
}

@end
