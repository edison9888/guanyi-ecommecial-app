//
//  StatusUtility.h
//  YK_Address
//
//  Created by fan wt on 11-9-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusUtility : NSObject

/**
    获取所有省市区
 */
+(NSArray*)getSystemAddressData;
/**
    根据Parent地址对象获取省市区
 */
+(NSArray*)SystemAddressDataWithParentId:(id)parentID;

/**
    拷贝数据库到Documents中
 */
+(void)buildDBDataFile;

/**
    拷贝数据库到Documents中
 */
+(void)createEditableCopyOfDatabaseIfNeeded :(NSString*) adbName fromDBName:(NSString*)fromDbName;

/**
 加载地址数据
 */
+(void)loadAllSystemAddressData;

@end
