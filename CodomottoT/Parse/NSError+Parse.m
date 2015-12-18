//
//  NSError+Parse.m
//  Codomotto
//
//  Created by Codomotto on 2015/07/28.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "NSError+Parse.h"

@implementation NSError (Parse)

+ (NSError*)errorWithCodomottoErrorCode:(CMTErrorCode)code
                   localizedDescription:(NSString* )localizedDescription{
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [[self class] errorWithDomain:CodomottoErrorDomain code:(NSInteger)code userInfo:userInfo];
    
    return error;
}

@end
