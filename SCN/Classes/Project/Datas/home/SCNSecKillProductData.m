//
//  SCNSecKillProductData.m
//  SCN
//
//  Created by xie xu on 11-10-20.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNSecKillProductData.h"

@implementation SCNSecKillProductData
@synthesize mname;
@synthesize mimage;
@synthesize mlimit;
@synthesize mendTime;
@synthesize mdiscount;
@synthesize mstartTime;
@synthesize mmarketPrice;
@synthesize mproductCode;
@synthesize mseckillPrice;
@synthesize mendTimeInterval;
@synthesize mpstatus;
@synthesize mstartTimeInterval;
@synthesize mstatus;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
