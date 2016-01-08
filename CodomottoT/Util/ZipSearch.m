//
//  ZipSearch.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/05.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "ZipSearch.h"

static NSString* const kRequestZipCodeSearchURL = @"http://zipcloud.ibsnet.co.jp/api/search?zipcode=";

@implementation ZipSearchResult

- (id)initWithDictionary:(NSDictionary *)dict {

    self = [super init];
    
    if (self) {
        
        _address1 = dict[@"address1"];
        _address2 = dict[@"address2"];
        _address3 = dict[@"address3"];
        _kana1 = dict[@"kana1"];
        _kana2 = dict[@"kana2"];
        _kana3 = dict[@"kana3"];
        _prefcode = dict[@"prefcode"];
        _zipcode = dict[@"zipcode"];
    }
    
    return self;
}

- (NSString *)description {

    NSMutableString *descString = [NSMutableString new];
    
    [descString appendFormat:@"\naddress1 = %@", _address1];
    [descString appendFormat:@"\naddress2 = %@", _address2];
    [descString appendFormat:@"\naddress3 = %@", _address3];
    [descString appendFormat:@"\nkana1 = %@", _kana1];
    [descString appendFormat:@"\nkana2 = %@", _kana2];
    [descString appendFormat:@"\nkana3 = %@", _kana3];
    [descString appendFormat:@"\nprefcode = %ld", (long)[_prefcode integerValue]];
    [descString appendFormat:@"\nzipcode = %ld", (long)[_zipcode integerValue]];
    
    return (NSString *)descString;
}

@end

@implementation ZipSearch

- (void)requestAddress:(NSString *)zipcode block:(void(^)(NSArray*))block {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kRequestZipCodeSearchURL,zipcode];

    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        
        if (block==nil) {
            return;
        }
        
        if (dict == nil
            || [dict[@"status"] intValue] != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
        
        NSMutableArray *address_results = [NSMutableArray new];
        for (NSDictionary *address_dict in dict[@"results"]) {
            ZipSearchResult *address = [[ZipSearchResult alloc] initWithDictionary:address_dict];
            [address_results addObject:address];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(address_results);
        });

//        {
//            message = "<null>";
//            results =     (
//                           {
//                               address1 = "\U6771\U4eac\U90fd";
//                               address2 = "\U5317\U533a";
//                               address3 = "\U8d64\U7fbd\U53f0";
//                               kana1 = "\Uff84\Uff73\Uff77\Uff6e\Uff73\Uff84";
//                               kana2 = "\Uff77\Uff80\Uff78";
//                               kana3 = "\Uff71\Uff76\Uff8a\Uff9e\Uff88\Uff80\Uff9e\Uff72";
//                               prefcode = 13;
//                               zipcode = 1150053;
//                           }
//                           );
//            status = 200;
//        }
        
        
    }] resume];
    
    
}

@end
