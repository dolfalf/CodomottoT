//
//  UIImage+Resize.m
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

+ (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    CGSize resizedSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resizedSize);
    [image drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

@end
