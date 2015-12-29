//
//  UIImage+Resize.h
//  CodomottoT
//
//  Created by lee jaeeun on 2015/12/29.
//  Copyright © 2015年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;
@end
