//
//  NSError+Parse.h
//  Codomotto
//
//  Created by Codomotto on 2015/07/28.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseModel.h"

@interface NSError (Parse)

#define CodomottoErrorDomain @"com.codomotto.error"

+ (NSError*)errorWithCodomottoErrorCode:(CMTErrorCode)code
                   localizedDescription:(NSString* )localizedDescription;

@end
