//
//  ContactRead.h
//  Codomotto
//
//  Created by kjcode on 2015/07/27.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import <Parse/Parse.h>

@class Contact;

/*!
 * 既読の表示のためのクラス。
 * 該当連絡帳にアクセスしたユーザーを保存する。
 */
@interface ContactRead : PFObject<PFSubclassing>

@property (nonatomic, strong) Contact *contact;
@property (nonatomic, strong) PFRelation *readUsers;    //既読ユーザー
@property (nonatomic, assign) BOOL deleteFlag;          //default NO.
@property (nonatomic, strong) PFACL *ACL;               //set Role.

+ (NSString *)parseClassName;
+ (instancetype)createModel;
@end
