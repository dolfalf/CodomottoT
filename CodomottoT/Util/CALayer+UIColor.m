//
//  CALayer+UIColor.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/07.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
