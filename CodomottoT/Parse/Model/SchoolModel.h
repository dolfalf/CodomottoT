//
//  SchoolModel.h
//  Codomotto
//
//  Created by kjcode on 2015/07/08.
//  Copyright (c) 2015年 Codomotto. All rights reserved.
//

#import "Model.h"
#import "School.h"

@interface SchoolModel : Model

/*!
 * 園長が新しくSchoolを登録するときに使う。
 * Schoolを作成した後、園にアクセスできるようにRoleも作成する。
 *
 */
- (void)registSchool:(School *)school completion:(void(^)(BOOL succeeded, NSError* resultError))completion;
@end
