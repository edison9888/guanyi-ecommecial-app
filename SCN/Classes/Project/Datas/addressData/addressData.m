//
//  addressData.m
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addressData.h"


@implementation addressData
@synthesize maddressId;
@synthesize mdefault;
@synthesize mconsignee;
@synthesize msex;
@synthesize maddressdetail;
@synthesize mprovince;
@synthesize mcity;
@synthesize marea;
@synthesize mprovinceId;
@synthesize mcityId;
@synthesize mareaId;
@synthesize mphone;


- (id)copyWithZone:(NSZone *)zone
{
	addressData* copy = [[[self class] allocWithZone: zone] init];
	copy.maddressId = [maddressId copy];
	copy.mdefault = [mdefault copy];
	copy.mconsignee = [mconsignee copy];
	copy.msex = [msex copy];
	copy.maddressdetail = [maddressdetail copy];
	copy.mprovince = [mprovince copy];
	copy.mcity = [mcity copy];
	copy.marea = [marea copy];
	copy.mprovinceId = [mprovinceId copy];
	copy.mcityId = [mcityId copy];
	copy.mareaId = [mareaId copy];
	copy.mphone = [mphone copy];
	return copy;
}
@end
