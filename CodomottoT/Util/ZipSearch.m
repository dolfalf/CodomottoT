//
//  ZipSearch.m
//  CodomottoT
//
//  Created by lee jaeeun on 2016/01/05.
//  Copyright © 2016年 kjcode. All rights reserved.
//

#import "ZipSearch.h"

static NSString* const kRequestZipCodeSearchURL = @"http://zipcloud.ibsnet.co.jp/api/search?zipcode=";

@implementation ZipSearch

- (void)requestAddress:(NSString *)zipcode {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kRequestZipCodeSearchURL,zipcode];

    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        
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
