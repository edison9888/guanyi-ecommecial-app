//
//  OffShoppingCartData.m
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OffShoppingCartData.h"


@implementation OffShoppingCartData


+(OffShoppingCartData*)existsInDBWithSku:(NSString*)sku{
	OffShoppingCartData* _goodsData = (OffShoppingCartData*)[OffShoppingCartData 
															 findFirstByCriteria:[NSString stringWithFormat:@"WHERE msku='%@'", sku]];
	return _goodsData;
}

+(void)saveWithSku:(NSString*)sku withProductCode:(NSString*)productCode withNumber:(int)num{
	OffShoppingCartData* _goodsData = [ self existsInDBWithSku:sku];
	if (_goodsData) {  // 数据库中已存在
		int _count = _goodsData.mnumber + num;
		OffShoppingCartData* _g = [[OffShoppingCartData alloc] init];
		_g.msku = _goodsData.msku;
		_g.mproductCode = _goodsData.mproductCode;
		_g.mnumber = _count;
		[_goodsData deleteObject];
		[_g save];
	}else {
		OffShoppingCartData* _g = [[OffShoppingCartData alloc] init];
		_g.msku = sku;
		_g.mnumber = num;
		_g.mproductCode = productCode;
		[_g save];
	}
}

+(NSInteger)getOffShoppingCartDataNumberBySku:(NSString*)sku{
	OffShoppingCartData* _goodsData = [ self existsInDBWithSku:sku];
	if (_goodsData) {
		return _goodsData.mnumber;
	}else {
		return 0;
	}
    
}


@end
