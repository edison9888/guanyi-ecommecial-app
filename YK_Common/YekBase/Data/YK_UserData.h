//
//  YK_UserData.h
//  m5173
//
//  Created by blackApple-1 on 11-7-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/**
	用户信息类，具备数据库保存的功能
 */


#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface YK_UserData : YK_BaseData {
	NSMutableDictionary* m_dic_userData;
}
@property (nonatomic,strong) NSMutableDictionary* m_dic_userData;
@end
