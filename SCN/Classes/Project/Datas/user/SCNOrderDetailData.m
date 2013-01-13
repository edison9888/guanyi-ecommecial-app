//
//  SCNOrderDetailData.m
//  SCN
//
//  Created by chenjie on 11-10-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNOrderDetailData.h"


@implementation SCNOrderDetailData
@synthesize morderId;
@synthesize morderStatus;
@synthesize morderTime;
@synthesize mtotalMoney;
@synthesize mfreight;
@synthesize msavePrice;
@synthesize msavePhonePrice;
@synthesize mpayMoney;
@synthesize mnumber;
@synthesize maddress;
@synthesize mconsignee;
@synthesize mphone;
@synthesize mpayType;
@synthesize mlogisticsTrack;
@synthesize mprovince;
@synthesize mcity;
@synthesize marea;
@synthesize mmsg;

@synthesize m_mutarray_productlist,m_mutarray_status;

-(id)init
{
    if (self == [super init]) {
  //      self.m_mutarray_productlist = [NSMutableArray arrayWithCapacity:0];
    }

    return self;
}
@end

@implementation SCNOrderProductListData
@synthesize msku,mname,mimage,mnumber,msellPrice,mproductCode,mpstatus;

@end

@implementation SCNOrderStatusData
            
@synthesize mstatus,mtime;

@end
