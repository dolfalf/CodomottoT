//
//  ZipSearch.h
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/05.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipSearchResult : NSObject

@property (nonatomic,strong) NSString *address1;
@property (nonatomic,strong) NSString *address2;
@property (nonatomic,strong) NSString *address3;
@property (nonatomic,strong) NSString *kana1;
@property (nonatomic,strong) NSString *kana2;
@property (nonatomic,strong) NSString *kana3;
@property (nonatomic,strong) NSNumber *prefcode;
@property (nonatomic,strong) NSNumber *zipcode;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

@interface ZipSearch : NSObject

- (void)requestAddress:(NSString *)zipcode block:(void(^)(ZipSearchResult*))block;
@end
