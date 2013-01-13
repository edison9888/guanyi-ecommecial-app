//
//  YK_BaseDataSource.m
//  m5173
//
//  Created by blackApple-1 on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_BaseDataSource.h"
#import "YK_BaseData.h"
#import "YK_Params.h"
#import <UIKit/UIKit.h>
#import "SCNAppDelegate.h"
@implementation YK_BaseDataSource
@synthesize m_data;
@synthesize m_params;
@synthesize m_activityIndicator;
@synthesize delegate;
@synthesize tag;

-(void)startAsyncData{
	[delegate YK_DataRequestDelegateWillSendRequest:m_params withDataSource:self];
}

-(void)onAsyncDataResponse:(NSObject*)response{
	[self.m_activityIndicator stopAnimating];
	[delegate YK_DataRequestDelegateDataResponse:response withDataSource:self];
}

-(void)setIntValue:(int)value forKey:(NSString*)key{
	[m_params setIntValue:value forKey:key];
}

-(void)setBoolValue:(BOOL)value forKey:(NSString*)key{
	[m_params setBoolValue:value forKey:key];
}

-(void)setStringValue:(NSString*)value forKey:(NSString*)key{
	[m_params setStringValue:value forKey:key];
}

-(int)getIntValueForKey:(NSString*)key{
	return [m_params getIntValueForKey:key];
}

-(BOOL)getBoolValueForKey:(NSString*)key{
	return [m_params getBoolValueForKey:key];
}

-(NSString*)getStringValueForKey:(NSString*)key{
	return [m_params getStringValueForKey:key];
}

-(void)dealloc{
	NSLog( @"[SYS]%@ %@", [self class], NSStringFromSelector(_cmd) );
}

@end
