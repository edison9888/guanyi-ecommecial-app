//
//  SCNClassfiledData.m
//  SCN
//
//  Created by yuanli on 11-10-9.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNClassfiledData.h"

@implementation SCNClassfiledData


@end


@implementation Category_Data

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