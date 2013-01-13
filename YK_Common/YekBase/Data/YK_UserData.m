//
//  YK_UserData.m
//  m5173
//
//  Created by blackApple-1 on 11-7-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_UserData.h"

@implementation YK_UserData
@synthesize m_dic_userData;

-(id)init{
	self = [super init];
	
	if ( self != nil ) {
		m_dic_userData = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


@end
