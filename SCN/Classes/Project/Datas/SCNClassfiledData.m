//
//  SCNClassfiledData.m
//  SCN
//
//  Created by yuanli on 11-10-9.
//  Copyright 2011 Yek.me. All rights reserved.
//

#import "SCNClassfiledData.h"

@implementation SCNClassfiledData

@synthesize micon,mname,mfatherId,mcategoryId,mchildNum,mbrandId;
-(void)dealloc
{
    [micon release],micon = nil;
    [mname release],mname = nil;
    [mfatherId release],mfatherId = nil;
    [mcategoryId release],mcategoryId = nil;
    [mchildNum release],mchildNum = nil;
    [mbrandId release], mbrandId = nil;
    [super dealloc];
}

@end
