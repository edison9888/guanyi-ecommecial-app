//
//  SCNCashCenterData.m
//  SCN
//
//  Created by huangwei on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCashCenterData.h"


@implementation SCNCashCenterData
@synthesize mPriceInfoData;
@synthesize mAddressData;
@synthesize mCouponArray;
@synthesize mPayTypeArray;
@synthesize mInvoiceTypeData;
@synthesize mProductListData;
@synthesize mCoupon;
@synthesize mprompt;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end

@implementation cashcenterAddressData
@synthesize maddressId;
@synthesize mconsignee;
@synthesize mphone;
@synthesize mselected;
@synthesize maddressInfo;
@synthesize mprovince;
@synthesize mcity;
@synthesize marea;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation cashcenterCouponData
@synthesize mcouponId;
@synthesize mselected;
@synthesize mcouponInfo;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation cashcenterInvoiceTypeData
@synthesize mselected;
@synthesize minvoiceTypeInfo;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation cashcenterProductListData
@synthesize mnumber;
@synthesize mkeyword;
@synthesize mtype;
@synthesize mpage;
@synthesize mpageSize;
@synthesize mtotalPage;
@synthesize mitems;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end


@implementation cashcenterProductData
@synthesize mimage;
@synthesize mname;
@synthesize msavePrice;
@synthesize msellPrice;
@synthesize mcomment;
@synthesize msku;
@synthesize mtype;
@synthesize mtypeImage;
@synthesize mbigImage;
@synthesize mproductCode;
@synthesize mbrand;
@synthesize mbrandId;
@synthesize mcategoryId;
@synthesize mnumber;
@synthesize mcolor;
@synthesize msize;
@synthesize mpstatus;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation cashcenterOrderInfoData
@synthesize morderId;
@synthesize mprice;
@synthesize mfreight;
@synthesize msavePrice;
@synthesize msellPrice;
@synthesize msavePhonePrice;
@synthesize mnumber;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end


@implementation cashcenterPayTypeData
@synthesize mpayTypeId;
@synthesize mselected;
@synthesize mpayTypeName;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end


