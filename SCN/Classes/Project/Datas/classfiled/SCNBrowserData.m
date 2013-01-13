//
//  SCNBrowserData.m
//  SCN
//
//  Created by user on 11-10-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNBrowserData.h"

@implementation SCNBrowserData
@synthesize mproudctCode,mimageUrl;
@synthesize mname,msex,mbrand,mpstatus,mmarketPrice,msellPrice,mbn;
DECLARE_PROPERTIES(
                   DECLARE_PROPERTY(@"mproudctCode", @"@\"NSString\""), 
				   DECLARE_PROPERTY(@"mimageUrl", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mname", @"@\"NSString\""), 
				   DECLARE_PROPERTY(@"msex", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mbrand", @"@\"NSString\""), 
				   DECLARE_PROPERTY(@"mpstatus", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mmarketPrice", @"@\"NSString\""), 
				   DECLARE_PROPERTY(@"msellPrice", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mbn", @"@\"NSString\"")
				   )
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mproudctCode = nil;
    mimageUrl = nil;
    
    mname = nil;
    msex = nil;
    mbrand = nil;
    mpstatus = nil;
    mmarketPrice = nil;
    msellPrice = nil;
    mbn = nil;
}
-(BOOL)existsInDB{
    NSLog(@"%@",self.mproudctCode);
    SCNBrowserData* _browserData = (SCNBrowserData*)[SCNBrowserData 
															 findFirstByCriteria:[NSString stringWithFormat:@"WHERE mproudct_code='%@'",self.mproudctCode]];

	if (_browserData) {
		return YES;
	}else {
		return NO;
	}
	
}
-(void)save{
	if (![self existsInDB]) {
		[super save];
	}else {
        NSLog(@"已存在");
		NSLog(@"%@ 已存在。", self);
	}
}

@end

@implementation SCNNowProductData
@synthesize m_productName;
@synthesize m_productCode;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end

@implementation SCNNowClassifiedData
@synthesize m_classifiedName;
@synthesize m_parentClassifiedName;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end


