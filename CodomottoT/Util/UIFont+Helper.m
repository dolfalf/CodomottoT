//
//  UIFont+Helper.m
//  Codomotto
//
//  Created by kjcode on 2014/12/06.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import "UIFont+Helper.h"
#import "Util.h"


@implementation UIFont (Helper)

#pragma mark - Regular
+ (UIFont *)CMTRegularFontSizeLL {
    return [UIFont systemFontOfSize:30.f];
}

+ (UIFont *)CMTRegularFontSizeL {
    return [UIFont systemFontOfSize:24.f];
}

+ (UIFont *)CMTRegularFontSizeM {
    return [UIFont systemFontOfSize:16.f];
}

+ (UIFont *)CMTRegularFontSizeS {
    return [UIFont systemFontOfSize:14.f];
}

+ (UIFont *)CMTRegularFontSizeSS {
    return [UIFont systemFontOfSize:12.f];
}

#pragma mark - Bold
+ (UIFont *)CMTBoldFontSizeLL {
    return [UIFont boldSystemFontOfSize:30.f];
}

+ (UIFont *)CMTBoldFontSizeL {
    return [UIFont boldSystemFontOfSize:24.f];
}

+ (UIFont *)CMTBoldFontSizeM {
    return [UIFont boldSystemFontOfSize:16.f];
}

+ (UIFont *)CMTBoldFontSizeS {
    return [UIFont boldSystemFontOfSize:14.f];
}

+ (UIFont *)CMTBoldFontSizeSS {
    return [UIFont systemFontOfSize:12.f];
}



@end
