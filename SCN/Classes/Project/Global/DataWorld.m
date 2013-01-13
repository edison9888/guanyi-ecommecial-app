//
//  DataWorld.m
//  Moonbasa
//
//  Created by user on 11-7-7.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "DataWorld.h"
#import "YKHttpAPIHelper.h"
#define APPStartTimes @"SelfAppStartTimes"


static DataWorld* s_dataWorld = nil;

@interface DataWorld(privateMethods)
-(void)realRelease;
@end

@implementation DataWorld

@synthesize mainWindow = m_mainWindow;
@synthesize m_homeData,m_switchSizeData,m_nowProductData,m_nowClassifiedData;
+(DataWorld*)shareData
{
	@synchronized(self)
	{
		if (s_dataWorld==nil)
		{
			s_dataWorld = [[self alloc] init];		
		}
	}
	return s_dataWorld;
}

- (void)DealAppStartTimes
{
	int value = [self getAppStartTimes];
	value++;
	[self setAppStartTimes:value];
}

-(NSString*)getSourceId{
	
	NSString* sourceid = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SOURCEID];
	if (sourceid && [sourceid length] > 0) {
		return sourceid;
	}
	[self reSetSourceId];

	sourceid = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SOURCEID];
	return sourceid;
}

-(NSString*)getSubSourceId
{
	NSString* subsourceid = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SUBSOURCEID];
	if (subsourceid && [subsourceid length] > 0) {
		return subsourceid;
	}
	[self reSetSourceId];

	subsourceid = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SUBSOURCEID];
	return subsourceid;
}

-(void)reSetSourceId
{
	[self setSourceId:getSourceID() subSourceId:getSubSourceID()];
}

-(void)setSourceId:(NSString*)sourceId subSourceId:(NSString*)subSourceId
{
	NSString* source_id = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SOURCEID];
	NSString* subsource_id = [[NSUserDefaults standardUserDefaults] stringForKey:YK_KEY_SUBSOURCEID];
	if (source_id && [source_id length] && subsource_id && [subsource_id length])
	{
		return;
	}
	[[NSUserDefaults standardUserDefaults] setValue:sourceId forKey:YK_KEY_SOURCEID];
	[[NSUserDefaults standardUserDefaults] setValue:subSourceId forKey:YK_KEY_SUBSOURCEID];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)getAppStartTimes
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:APPStartTimes];
}

- (void)setAppStartTimes:(int)times
{
	[[NSUserDefaults standardUserDefaults] setInteger:times forKey:APPStartTimes];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) DealWithFirstInstall
{
	
}

- (id)init
{
	if (self = [super init])
	{
		//deal with appstarttimes
		[self DealAppStartTimes];
		
		if ([self getAppStartTimes] == 1) 
		{
			[self DealWithFirstInstall];
		}
		[self reSetSourceId];
	}
	return self;
}

+(id) allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (s_dataWorld == nil)
		{
            s_dataWorld = [super allocWithZone:zone];
			
			return s_dataWorld;
		}
	}
	
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)setMainWindow:(UIWindow *)window
{
	m_mainWindow = window;
}



+ (NSString *)getResourcePath:(NSString*)path
{
	return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], path];
}

+ (UIImage *)getImageWithFile:(NSString*)path
{
	//return [UIImage imageWithContentsOfFile: [DataWorld getResourcePath:path]];
	return [UIImage imageNamed:path];
}


#pragma mark -
#pragma mark parse data function

@end


