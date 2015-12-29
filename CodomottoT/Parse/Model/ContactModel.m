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

@implementation ContactModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _fetchContactLimit = 30;    //default
    }
    
    return self;
}
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)fetchContacts:(NSInteger)startIndex block:(void(^)(NSArray *, NSError *))block {
    
    NSLog(@"%s", __FUNCTION__);
    
    PFQuery *query = [PFQuery queryWithClassName:[Contact parseClassName]];
    query.limit = _fetchContactLimit;
    query.skip = startIndex;    //skip the first 30 results
    
    [query findObjectsInBackgroundWithBlock:[block copy]];
    
}

- (void)postContact:(NSString *)content photoItems:(NSArray *)photoItems block:(boolBlock)block {
    
    NSLog(@"%s", __FUNCTION__);
    
    //UI系クラスはスレッド前に処理しておく。
    NSMutableArray *photoDatas = [NSMutableArray new];
    for (UIImage *photo in photoItems) {
        NSData *photoData = UIImagePNGRepresentation(photo);
        [photoDatas addObject:photoData];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //role info
        PFACL *contact_acl = [PFACL ACL];
        
        CMTParseManager *mgr = [CMTParseManager sharedInstance];
        [contact_acl setWriteAccess:YES forRole:[mgr roleInfo:kCMTRoleNameHeadTeacher]];
        [contact_acl setReadAccess:YES forRole:[mgr roleInfo:kCMTRoleNameMember]];
        [contact_acl setWriteAccess:YES forUser:[mgr currentUser]];
        
        //upload photo
        NSMutableArray *upload_photos = [NSMutableArray new];
        
        int index = 0;
        for (NSData *p_data in photoDatas) {
            
            NSString *photoFilename = [NSString stringWithFormat:@"CMT%03d.png", index];
            PFFile *photoFile = [PFFile fileWithName:photoFilename data:p_data];
            ContactPhoto *photo = [ContactPhoto createModel];
            photo.imageName = photoFilename;
            photo.imageFile = photoFile;
            
            [upload_photos addObject:photo];
            
            index++;
        }
        
        //Contact info.
        Contact *contact = [Contact createModel];
        contact.content = content;
        contact.postUser = [User currentUser];
        
        //relation
        PFRelation *relation = [contact relationForKey:@"photo"];
        for (ContactPhoto *photo in upload_photos) {
            
            photo.ACL = contact_acl;
            
            BOOL b = [photo save];
            
            if(b == NO) {
                NSLog(@"photo save error.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        block(NO);
                    }
                });
                return;
            }
            
            [relation addObject:photo];
        }
        
        contact.ACL = contact_acl;
        
        //save.
        NSError *contact_error = nil;
        BOOL b = [contact save:&contact_error];
        
        if(contact_error) {
            NSLog(@"contact save error.");
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(b);
            }
        });
    });
}

@end

#pragma mark - Comment Category
@implementation ContactModel (Comment)

- (void)addComment:(NSString *)comment contact:(id)contact block:(boolBlock)block {

    NSLog(@"%s", __FUNCTION__);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //comment info.
        ContactComment *contact_comment = [ContactComment createModel];
        contact_comment.comment = comment;
        contact_comment.postContact = contact;
        
        //role info.
        contact_comment.ACL = [User currentUser].ACL;
        CMTParseManager *mgr = [CMTParseManager sharedInstance];
        PFACL *comment_acl = [PFACL ACL];
        [comment_acl setWriteAccess:YES forRole:[mgr roleInfo:kCMTRoleNameHeadTeacher]];
        [comment_acl setReadAccess:YES forRole:[mgr roleInfo:kCMTRoleNameMember]];
        
        BOOL comment_saved = [contact_comment save];
        
        if (comment_saved == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(NO);
                }
            });

            return;
        }
        
        //releation save.
        PFRelation *relation_comment = [contact relationForKey:@"comments"];
        [relation_comment addObject:contact_comment];
        
        NSError *contact_error = nil;
        BOOL contact_saved = [contact save:&contact_error];
        
        if (contact_saved == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(NO);
                }
            });
            return;
        }
        
        
        //TODO: お知らせ対応
#if 0
        //나중에 공지보기 화면에서 알림을 하기 위해 처리하는 부분.. 지금은 실장 안함
        //Notice trigger
        Notice *notice = [Notice createModel];
        notice.title = @"new comment";
        notice.relation_table = @"ContactComment";
        notice.relation_id = @(1111);
        //ACL설정
        notice.ACL = ??
        [notice saveInBackground];
#endif
        
        //finished
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
        
        
    });
    
}

- (void)modifyComment:(NSString *)comment model:(ContactComment *)model block:(boolBlock)block {
    NSLog(@"%s", __FUNCTION__);
    
    model.comment = comment;
    
    [model saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (block) {
            block(succeeded);
        }
    }];
}

- (void)removeComment:(ContactComment *)model block:(boolBlock)block {
    NSLog(@"%s", __FUNCTION__);
    
    [model deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (block) {
            block(succeeded);
        }
    }];
}

@end
