//
//  YK_WebDataSource.m
//  YKMAG
//
//  Created by blackApple-1 on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_WebDataSource.h"

@implementation YK_WebDataSource
@synthesize m_url;

-(id)initUrlRequest:(YK_Params*)params url:(NSString*)urlString{
	self = [super init];
	if ( self ) {
		self.m_params = params;
		m_url = [[NSURL alloc] initWithString:urlString];
	}
	return self;
}

-(void)startAsyncData{
	[super startAsyncData];
	YKHttpRequestHelper_NSString* aRequestHelper = [[YKHttpRequestHelper_NSString alloc] initWithObject:self action:@selector(onAsyncDataResponse:)];
	[YKHttpRequest startLoadUrl:m_url delegate:aRequestHelper params:[m_params m_mut_dictionary]];
}

-(void)onAsyncDataResponse:(NSObject *)response{
	[super onAsyncDataResponse:response];
}


@end
