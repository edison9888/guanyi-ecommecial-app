//
//  YKHttpRequestHelper+NSString.m
//  YKMAG
//
//  Created by guwei ZZZ on 11-7-18.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YKHttpRequestHelper+NSString.h"


@implementation YKHttpRequestHelper_NSString

-(id) initWithObject:(id)aobj action:(SEL)aaction{
	if(self=[super init]){
		object=aobj;
		action=aaction;
	}
	return self;
}

-(void) onLoadFinished:(NSString *)responseString{
#ifdef PRINTCONSOLE
	NSLog(@"-(void) onLoadFinished:(NSString *)responseString ... 返回字符串:\n%@",responseString);
#else
	NSLog( @"%@ request success response...", [object class] );
#endif
	[object performSelector:action withObject:responseString];
}
-(void) onLoadFailed:(NSError *)error{
	NSLog(@"!!!!warning %@-(void) onLoadFailed:(NSError *)error=%@ ...",[self class],error);
	NSString* retString = nil;
	[object performSelector:action withObject:retString];
}

@end
