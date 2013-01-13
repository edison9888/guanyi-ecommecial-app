//
//  YK_UserUtility.m
//  m5173
//
//  Created by blackApple-1 on 11-7-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_UserUtility.h"
#import "YK_UserData.h"

static YK_UserData* g_userData;

@implementation YK_UserUtility

+ (void)initialize{
	for ( YK_UserData* userData in [YK_UserData allObjects] ) {
		g_userData = userData;
	}
	
	if ( g_userData == nil ) {
		NSLog( @"用户尚未登陆。" );
		g_userData = [[YK_UserData alloc] init];
	}
}

+(void)userParamFromDictionary:(NSDictionary*)dictionary{
	for ( NSString* key in [dictionary allKeys] ) {
		[[g_userData m_dic_userData] setObject:[dictionary objectForKey:key] forKey:key];
	}
	
	[g_userData save];
}

+(void)setUserParam:(NSString*)param forKey:(NSString*)key{
	[[g_userData m_dic_userData] setObject:param forKey:key];
}

+(NSString*)userParamForKey:(NSString*)key{
	return [[g_userData m_dic_userData] objectForKey:key];
}

+(NSArray*)userAllKeyParams{
	return [[g_userData m_dic_userData] allKeys];
}

+(NSArray*)userAllParams{
	return [[g_userData m_dic_userData] allValues];
}
@end
