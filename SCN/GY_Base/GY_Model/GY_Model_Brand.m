//
//  GY_Model_Brand.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-11.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Model_Brand.h"

@implementation GY_Model_Brand

@synthesize mimage,mname,mbrandId,mtype;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    mimage = nil;
    mname = nil;
    mbrandId = nil;
    mtype = nil;
}
@end
