//
//  UIFont+Helper.h
//  Codomotto
//
//  Created by kjcode on 2014/12/06.
//  Copyright (c) 2014年 kjcode. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 문자굵기(f) :
 R (Regular)
 B (Bold)
 
 크기 (sz):
 SS (12)
 S (14)
 M (16)
 L (24)
 LL (30)
 
 정렬 (a):
 L (Left)
 C (Center)
 R (Right)
 J (Justify)

 사용예)
 CMT_INIT_LABEL(label,Reqular,L,Center)
*/

#define CMT_INIT_LABLE(l,f,sz,a)     l.font=[UIFont CMT##f##FontSize##sz];l.textAlignment = NSTextAlignment##a;

/*
 
 디자인 표기 규칙 : R_S_L_Normal10 : Regular Small Left Normal 10
                          문자 굵기 크기   정렬 색      투명도
 */

@interface UIFont (Helper)

+ (UIFont *)CMTRegularFontSizeLL;
+ (UIFont *)CMTRegularFontSizeL;
+ (UIFont *)CMTRegularFontSizeM;
+ (UIFont *)CMTRegularFontSizeS;
+ (UIFont *)CMTRegularFontSizeSS;

+ (UIFont *)CMTBoldFontSizeLL;
+ (UIFont *)CMTBoldFontSizeL;
+ (UIFont *)CMTBoldFontSizeM;
+ (UIFont *)CMTBoldFontSizeS;
+ (UIFont *)CMTBoldFontSizeSS;
@end
