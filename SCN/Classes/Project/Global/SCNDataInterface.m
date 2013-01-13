//
//  SCNDataInterface.m
//  SCN
//
//  Created by zwh on 11-10-8.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNDataInterface.h"
#import "YKStringUtility.h"


#pragma mark -
#pragma mark SourceId相关
//强制用来判断的测试sourceid
#define YK_TEST_SOURCEID					@"yek_iphone_test"

#if (defined(TEST_FOR_CUSTOMER) || defined(TEST_URL))

#define SCN_VALUE_SOURCEID					YK_TEST_SOURCEID

#else

//打包时修改
//TODO:
#define SCN_VALUE_SOURCEID					@"MxkTongbuI1"

#endif

#define SCN_VALUE_SUBSOURCEID				SCN_VALUE_SOURCEID


//#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

NSString *getSourceID(void)
{
	return SCN_VALUE_SOURCEID;
}

NSString *getSubSourceID(void)
{
	return SCN_VALUE_SUBSOURCEID;
}

BOOL isTestSourceID(void)
{
	NSString* sourceid = getSourceID();
	return [sourceid isEqualToString:YK_TEST_SOURCEID];
}