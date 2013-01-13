//
//  ShoppingCartData.m
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingCartData.h"

@implementation CartData
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
@synthesize mpstatus;
@synthesize mnumber;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mproductCode",@"@\"NSString\""),
				   DECLARE_PROPERTY(@"msku", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mnumber", @"@\"int\"")
				   )


@end


@implementation ShoppingCartData


+(ShoppingCartData*)existsInDBWithSku:(NSString*)sku{
	ShoppingCartData* _goodsData = (ShoppingCartData*)[ShoppingCartData 
													   findFirstByCriteria:[NSString stringWithFormat:@"WHERE msku='%@'", sku]];
	return _goodsData;
}

+(void)saveWithSku:(NSString*)sku withProductCode:(NSString*)productCode withNumber:(int)num{
	ShoppingCartData* _goodsData = [ self existsInDBWithSku:sku];
	if (_goodsData) {  // 数据库中已存在
		int _count = _goodsData.mnumber + num;
		ShoppingCartData* _g = [[ShoppingCartData alloc] init];
		_g.msku = _goodsData.msku;
		_g.mproductCode = _goodsData.mproductCode;
		_g.mnumber = _count;
		[_goodsData deleteObject];
		[_g save];
	}else {
		ShoppingCartData* _g = [[ShoppingCartData alloc] init];
		_g.msku = sku;
		_g.mproductCode = productCode;
		_g.mnumber = num;
		[_g save];
	}
}

+(NSInteger)getShoppingCartDataNumberBySku:(NSString*)sku{
	ShoppingCartData* _goodsData = [ self existsInDBWithSku:sku];
	if (_goodsData) {
		return _goodsData.mnumber;
	}else {
		return 0;
	}
	
}

@end
