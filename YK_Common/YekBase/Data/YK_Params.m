//
//  YK_Params.m
//  m5173
//
//  Created by blackApple-1 on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_Params.h"


@implementation YK_Params
@synthesize m_mut_dictionary;

-(id)init{
	self = [super init];
	
	if ( self != nil ) {
		m_mut_dictionary = [[NSMutableDictionary alloc] init];
		[self initializeBaseParams];
	}
	
	return self;
}

-(void)initializeBaseParams{
}

-(void)setIntValue:(int)value forKey:(NSString*)key{
	NSNumber* number = [[NSNumber alloc] initWithInt:value];
	[m_mut_dictionary setObject:number forKey:key];
}

-(void)setBoolValue:(BOOL)value forKey:(NSString*)key{
	NSNumber* boolNumer = [[NSNumber alloc] initWithBool:value];
	[m_mut_dictionary setObject:boolNumer forKey:key];
}

-(void)setStringValue:(NSString*)value forKey:(NSString*)key{
	[m_mut_dictionary setObject:value forKey:key];
}

-(int)getIntValueForKey:(NSString*)key{
	NSNumber* number = [m_mut_dictionary objectForKey:key];
	return [number intValue];
}

-(BOOL)getBoolValueForKey:(NSString*)key{
	NSNumber* number = [m_mut_dictionary objectForKey:key];
	return [number boolValue];
}

-(NSString*)getStringValueForKey:(NSString*)key{
	return [m_mut_dictionary objectForKey:key];
}

-(void)combineWithParams:(YK_Params*)tgParams{
	[self.m_mut_dictionary addEntriesFromDictionary:[tgParams m_mut_dictionary]];
}

@end
