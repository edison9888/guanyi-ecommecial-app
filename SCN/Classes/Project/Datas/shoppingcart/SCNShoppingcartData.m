//
//  SCNShoppingcartData.m
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNShoppingcartData.h"


@implementation SCNShoppingcartData
@synthesize sellingproducts;
@synthesize offsellingproducts;
@synthesize mpriceInfoData;
@synthesize m_prompt;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end

@implementation shoppingcartProductData

@synthesize mimage;
@synthesize mname;
@synthesize mcolor;
@synthesize msize;
@synthesize msavePrice;
@synthesize msellPrice;
@synthesize mproductCode;
@synthesize msku;
@synthesize mcategory;
@synthesize mbrand;
@synthesize mbrandId;
@synthesize mnumber;
@synthesize mpstatus;
@synthesize mpstatusDes;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation shoppingcartProductListData
@synthesize mnumber;
@synthesize mkeyword;
@synthesize mtype;
@synthesize mpage;
@synthesize mpageSize;
@synthesize mtotalPage;
@synthesize mitem;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


@end

@implementation shoppingcartPriceInfoData
@synthesize moriTotalPrice;
@synthesize msavePrice;
@synthesize msellPrice;
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

