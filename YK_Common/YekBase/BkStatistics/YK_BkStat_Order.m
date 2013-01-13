//
//  YK_BkStat_Order.m
//  Benefit
//
//  Created by Liu Yuhui on 11-9-20.
//  Copyright 2011年 YeKe.com. All rights reserved.
//

#import "YK_BkStat_Order.h"
#import "YK_BkStat_Protocol.h"


@implementation YK_BkStat_Order
@synthesize orderid;
@synthesize username;
@synthesize fullname;
@synthesize cellphone;
@synthesize province;
@synthesize city;
@synthesize county;
@synthesize address;
@synthesize amount;
@synthesize ordertime;
@synthesize itemdata;

-(id)initWithDictionary:(NSDictionary*)aDic
{
    if (self == [super init]) {
        self.orderid = [aDic objectForKey:YK_BKSTAT_ORDERINFO_orderid];
        self.username = [aDic objectForKey:YK_BKSTAT_username];
        self.fullname = [aDic objectForKey:YK_BKSTAT_ORDERINFO_fullname];
        self.cellphone = [aDic objectForKey:YK_BKSTAT_ORDERINFO_cellphone];
        self.province = [aDic objectForKey:YK_BKSTAT_ORDERINFO_province];
        self.city = [aDic objectForKey:YK_BKSTAT_ORDERINFO_city];
        self.county = [aDic objectForKey:YK_BKSTAT_ORDERINFO_county];
        self.address = [aDic objectForKey:YK_BKSTAT_ORDERINFO_address];
        self.amount = [aDic objectForKey:YK_BKSTAT_ORDERINFO_amount];
        self.ordertime = [aDic objectForKey:YK_BKSTAT_ORDERINFO_ordertime];
        self.itemdata = [aDic objectForKey:YK_BKSTAT_ORDERINFO_itemdata];
    }
	
	return self; 
}

-(NSDictionary*)dictionary
{
    return @{YK_BKSTAT_ORDERINFO_orderid: self.orderid,
            YK_BKSTAT_username: self.username,
            YK_BKSTAT_ORDERINFO_fullname: self.fullname,
            YK_BKSTAT_ORDERINFO_cellphone: self.cellphone,
            YK_BKSTAT_ORDERINFO_province: self.province,
            YK_BKSTAT_ORDERINFO_city: self.city,
            YK_BKSTAT_ORDERINFO_county: self.county,
            YK_BKSTAT_ORDERINFO_address: self.address,
            YK_BKSTAT_ORDERINFO_amount: self.amount,
            YK_BKSTAT_ORDERINFO_ordertime: self.ordertime,
            YK_BKSTAT_ORDERINFO_itemdata: self.itemdata};
}

@end

