//
//  ContactModel.m
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "ContactModel.h"
#import "ContactPhoto.h"
#import "User.h"

#import "CMTParseManager.h"

NSString * const kContactImageAssetKey = @"ContactImageAssetKey";
NSString * const kContactImageDataKey = @"ContactImageDataKey";

@implementation ContactModel

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
}
- (void)contactListWithStartIndex:(NSInteger)startIndex block:(void(^)(NSArray *, NSError *))block {
    NSLog(@"%s", __FUNCTION__);
    
    PFQuery *query = [PFQuery queryWithClassName:[Contact parseClassName]];
    query.limit = 30;
    query.skip = startIndex;    //skip the first 10 results
    
    [query findObjectsInBackgroundWithBlock:[block copy]];
    
}

- (void)postContact:(NSString *)title content:(NSString *)content imageItems:(NSArray *)items completion:(void(^)(BOOL))completion {
    NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //upload image
        NSMutableArray *upload_photos = [NSMutableArray new];
        
        int index = 0;
        for (NSDictionary *item in items) {
            
            //REMARK: 後で使うかもしれない。。。
            //NSDictionary *info = item[kContactImageAssetKey];
            
            NSString *image_name = [NSString stringWithFormat:@"contact_photo_%d", index];
            NSData *imageData = item[kContactImageDataKey];
            PFFile *imageFile = [PFFile fileWithName:image_name data:imageData];
            
            ContactPhoto *photo = [ContactPhoto new];
            photo.imageName = image_name;
            photo.imageFile = imageFile;
            
            [upload_photos addObject:photo];
        }
        
        Contact *contact = [Contact createModel];
        contact.title = title;
        contact.content = content;
        
        contact.postUser = [User currentUser];
        
        contact.ACL = [User currentUser].ACL;
        
        //relation
        PFRelation *relation = [contact relationForKey:@"photo"];
        for (ContactPhoto *photo in upload_photos) {
            
            photo.ACL = [User currentUser].ACL;
            
            BOOL b = [photo save];
            
            if(b == NO) {
                NSLog(@"photo save error.");
                completion(NO);
                return;
            }
            
            [relation addObject:photo];
        }
        
        [contact saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error) {
                completion(NO);
                NSLog(@"%@", error);
                return;
            }
            
            completion(succeeded);
        }];
        
    });
}

int comment_count = 0;
- (void)addComment:(NSString *)comment contact:(id)contact completion:(void(^)(BOOL))completion {

    NSLog(@"%s", __FUNCTION__);
    
    //comment모델 생성
    ContactComment *contact_comment = [ContactComment createModel];
    contact_comment.title = [NSString stringWithFormat:@"%@ %d", comment, comment_count++];
    contact_comment.content = comment;
    contact_comment.postContact = contact;
    
    //ACL설정
    contact_comment.ACL = [User currentUser].ACL;
    
    BOOL b = [contact_comment save];
    
    if (b) {
        //contact에 릴레이션 한다.
        PFRelation *relation_comment = [contact relationForKey:@"comments"];
        [relation_comment addObject:contact_comment];
        [contact saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //
            if (error) {
                //error
                completion(NO);
                return;
            }
            
            completion(YES);
            
        }];
    }
    
    
#if 0
    //나중에 공지보기 화면에서 알림을 하기 위해 처리하는 부분.. 지금은 실장 안함
    //Notice trigger
    Notice *notice = [Notice object];
    notice.title = @"new comment";
    notice.relation_table = @"ContactComment";
    notice.relation_id = @(1111);
    //ACL설정
    notice.ACL = ??
    [notice saveInBackground];
#endif
}

- (void)modifyComment:(NSString *)comment model:(ContactComment *)model {
    model.content = comment;
    [model save];
}

- (void)removeComment:(ContactComment *)model {
    [model delete];
}

@end
