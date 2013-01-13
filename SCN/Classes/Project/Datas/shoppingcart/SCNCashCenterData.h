//
//  SCNCashCenterData.h
//  SCN
//
//  Created by huangwei on 11-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@class cashcenterOrderInfoData;
@class cashcenterAddressData;
@class cashcenterCouponData;
@class cashcenterInvoiceTypeData;
@class cashcenterProductListData;

@interface SCNCashCenterData : NSObject {
	cashcenterOrderInfoData* mPriceInfoData;
	cashcenterAddressData* mAddressData;
	NSMutableArray* mPayTypeArray;
	NSMutableArray* mCouponArray;
	NSString* mCoupon;
    NSString* mprompt;
	cashcenterInvoiceTypeData* mInvoiceTypeData;
	//cashcenterProductListData* mProductListData;
	NSMutableArray* mProductListData;
}
@property(nonatomic,strong)cashcenterOrderInfoData* mPriceInfoData;
@property(nonatomic,strong)cashcenterAddressData* mAddressData;
@property(nonatomic,strong)NSMutableArray* mCouponArray;
@property(nonatomic,strong)NSMutableArray* mPayTypeArray;
@property(nonatomic,strong)cashcenterInvoiceTypeData* mInvoiceTypeData;
//@property(nonatomic,retain)cashcenterProductListData* mProductListData;
@property(nonatomic,strong)NSMutableArray* mProductListData;
@property(nonatomic,strong)NSString* mCoupon;
@property(nonatomic,strong)NSString* mprompt;
@end

@interface cashcenterAddressData : YK_BaseData
{
	NSString* maddressId;
	NSString* mconsignee;
	NSString* mphone;
	NSString* mselected;
	NSString* maddressInfo;
	NSString* mprovince;
	NSString* mcity;
	NSString* marea;
}
@property(nonatomic,strong)NSString* maddressId;
@property(nonatomic,strong)NSString* mconsignee;
@property(nonatomic,strong)NSString* mphone;
@property(nonatomic,strong)NSString* mselected;
@property(nonatomic,strong)NSString* maddressInfo;
@property(nonatomic,strong)NSString* mprovince;
@property(nonatomic,strong)NSString* mcity;
@property(nonatomic,strong)NSString* marea;

@end

@interface cashcenterCouponData : YK_BaseData
{
	NSString* mcouponId;
	NSString* mselected;
	NSString* mcouponInfo;
}
@property(nonatomic,strong)NSString* mcouponId;
@property(nonatomic,strong)NSString* mselected;
@property(nonatomic,strong)NSString* mcouponInfo;

@end

@interface cashcenterInvoiceTypeData : YK_BaseData
{
	NSString* mselected;
	NSString* minvoiceTypeInfo;
}
@property(nonatomic,strong)NSString* mselected;
@property(nonatomic,strong)NSString* minvoiceTypeInfo;

@end

@interface cashcenterProductListData : YK_BaseData
{
	NSString* mnumber;
	NSString* mkeyword;
	NSString* mtype;
	NSString* mpage;
	NSString* mpageSize;
	NSString* mtotalPage;
	NSMutableArray* mitems;
}
@property(nonatomic,strong)NSString* mnumber;
@property(nonatomic,strong)NSString* mkeyword;
@property(nonatomic,strong)NSString* mtype;
@property(nonatomic,strong)NSString* mpage;
@property(nonatomic,strong)NSString* mpageSize;
@property(nonatomic,strong)NSString* mtotalPage;
@property(nonatomic,strong)NSMutableArray* mitems;

@end

@interface cashcenterProductData : YK_BaseData
{
	NSString* mimage;
	NSString* mname;
	NSString* msavePrice;
	NSString* msellPrice;
	NSString* mcomment;
	NSString* msku;
	NSString* mtype;
	NSString* mtypeImage;
	NSString* mbigImage;
	NSString* mproductCode;
	NSString* mbrand;
	NSString* mbrandId;
	NSString* mcategoryId;
	NSString* mnumber;
	NSString* mcolor;
	NSString* msize;
	NSString* mpstatus;
}
@property(nonatomic,strong)NSString* mpstatus;
@property(nonatomic,strong)NSString* mimage;
@property(nonatomic,strong)NSString* mname;
@property(nonatomic,strong)NSString* msavePrice;
@property(nonatomic,strong)NSString* msellPrice;
@property(nonatomic,strong)NSString* mcomment;
@property(nonatomic,strong)NSString* msku;
@property(nonatomic,strong)NSString* mtype;
@property(nonatomic,strong)NSString* mtypeImage;
@property(nonatomic,strong)NSString* mbigImage;
@property(nonatomic,strong)NSString* mproductCode;
@property(nonatomic,strong)NSString* mbrand;
@property(nonatomic,strong)NSString* mbrandId;
@property(nonatomic,strong)NSString* mcategoryId;
@property(nonatomic,strong)NSString* mnumber;
@property(nonatomic,strong)NSString* mcolor;
@property(nonatomic,strong)NSString* msize;

@end


@interface cashcenterOrderInfoData : YK_BaseData
{
	NSString* morderId;
	NSString* mprice;
	NSString* mfreight;
	NSString* msavePrice;
	NSString* msavePhonePrice;
	NSString* msellPrice;
	NSString* mnumber;
}
@property(nonatomic,strong)NSString* morderId;
@property(nonatomic,strong)NSString* mprice;
@property(nonatomic,strong)NSString* mfreight;
@property(nonatomic,strong)NSString* msavePrice;
@property(nonatomic,strong)NSString* msavePhonePrice;
@property(nonatomic,strong)NSString* msellPrice;
@property(nonatomic,strong)NSString* mnumber;
@end

@interface cashcenterPayTypeData : YK_BaseData
{
	NSString* mpayTypeId;
	NSString* mselected;
	NSString* mpayTypeName;
}

@property(nonatomic,strong)NSString* mpayTypeId;
@property(nonatomic,strong)NSString* mselected;
@property(nonatomic,strong)NSString* mpayTypeName;

@end


