//
//  SCN_SystemAddressData.m
//  SCN
//
//  Created by user on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCN_SystemAddressData.h"


@implementation SCN_SystemAddressData
@synthesize mparentid;
@synthesize mid;
@synthesize mname;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mparentid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mname", @"@\"NSString\"")
				   )


- (NSString *)description{
	return mname;
}

@end
