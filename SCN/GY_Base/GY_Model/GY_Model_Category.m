//
//  GY_Model_Category.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Model_Category.h"

@implementation GY_Model_Category

@synthesize mimage,mname,mfatherId,mcategoryId,mchildNum;

-(void)dealloc
{
    mimage = nil;
    mname = nil;
    mfatherId = nil;
    mcategoryId = nil;
    mchildNum = nil;
}


@end
