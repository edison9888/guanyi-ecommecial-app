//
//  SCNShoppingcartData.h
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@class shoppingcartProductListData;
@class shoppingcartPriceInfoData;

@interface SCNShoppingcartData : NSObject {
	NSMutableArray* sellingproducts;
	NSMutableArray* offsellingproducts;//已下架或者卖出的商品
	shoppingcartPriceInfoData* mpriceInfoData;
	NSString* m_prompt;
}
@property(nonatomic,strong)NSMutableArray* sellingproducts;
@property(nonatomic,strong)NSMutableArray* offsellingproducts;
@property(nonatomic,strong)shoppingcartPriceInfoData* mpriceInfoData;
@property(nonatomic,strong)NSString* m_prompt;

@end

/*...................................................*/

@interface shoppingcartProductData : YK_BaseData
{
	NSString* mimage;
	NSString* mname;
	NSString* msavePrice;
	NSString* msellPrice;
	NSString* msku;
	NSString* mproductCode;
	NSString* msize;
	NSString* mbrand;
	NSString* mbrandId;
	NSString* mcategory;
	NSString* mnumber;
	NSString* mcolor;
	NSString* mpstatus;
	NSString* mpstatusDes;
}

@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *mname;
@property (nonatomic, strong) NSString *msavePrice;
@property (nonatomic, strong) NSString *msellPrice;
@property (nonatomic, strong) NSString *msku;
@property (nonatomic, strong) NSString *mproductCode;
@property (nonatomic, strong) NSString *msize;
@property (nonatomic, strong) NSString *mbrand;
@property (nonatomic, strong) NSString *mbrandId;
@property (nonatomic, strong) NSString *mcategory;
@property (nonatomic, strong) NSString *mnumber;
@property (nonatomic, strong) NSString *mcolor;
@property (nonatomic, strong) NSString *mpstatus;
@property (nonatomic, strong) NSString* mpstatusDes;

@end

@interface shoppingcartProductListData : YK_BaseData
{
	NSString* mnumber;
	NSString* mkeyword;
	NSString* mtype;
	NSString* mpage;
	NSString* mpageSize;
	NSString* mtotalPage;
	
	NSMutableArray* mitem;
}

@property (nonatomic, strong) NSString *mnumber;
@property (nonatomic, strong) NSString *mkeyword;
@property (nonatomic, strong) NSString *mtype;
@property (nonatomic, strong) NSString *mpage;
@property (nonatomic, strong) NSString *mpageSize;
@property (nonatomic, strong) NSString *mtotalPage;
@property (nonatomic, strong) NSMutableArray* mitem;

@end

@interface shoppingcartPriceInfoData : YK_BaseData
{
	NSString* moriTotalPrice;
	NSString* msavePrice;
	NSString* msellPrice;
	NSString* mnumber;
}

@property (nonatomic, strong) NSString *moriTotalPrice;
@property (nonatomic, strong) NSString *msavePrice;
@property (nonatomic, strong) NSString *msellPrice;
@property (nonatomic, strong) NSString *mnumber;

@end



