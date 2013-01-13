//
//  ShoppingCartData.h
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface CartData : YK_BaseData
{
	NSString* mimage;
	NSString* mname;
	NSString* msavePrice;
	NSString* msellPrice;
	NSString* msku;
	NSString* mproductCode;
	NSString* mcolor;
	NSString* msize;
	NSString* mbrand;
	NSString* mbrandId;
	NSString* mcategory;
	NSString* mpstatus;
	int mnumber;
}

@property(nonatomic,strong)NSString* mimage;
@property(nonatomic,strong)NSString* mname;
@property(nonatomic,strong)NSString* mcolor;
@property(nonatomic,strong)NSString* msize;
@property(nonatomic,strong)NSString* msavePrice;
@property(nonatomic,strong)NSString* msellPrice;
@property(nonatomic,strong)NSString* mproductCode;
@property(nonatomic,strong)NSString* msku;
@property(nonatomic,strong)NSString* mcategory;
@property(nonatomic,strong)NSString* mbrand;
@property(nonatomic,strong)NSString* mbrandId;
@property(nonatomic,strong)NSString* mpstatus;
@property(nonatomic,assign)int mnumber;

@end


@interface ShoppingCartData : CartData {

}

/**
 添加购物车
 @param sku 商品唯一编号
 @param num 数量
 */
+(void)saveWithSku:(NSString*)sku withProductCode:(NSString*)productCode withNumber:(int)num;

+(ShoppingCartData*)existsInDBWithSku:(NSString*)sku;

/**
 根据商品sku查找购物车中的数量
 @param sku 商品sku
 @returns sku商品的数量
 */
+(NSInteger)getShoppingCartDataNumberBySku:(NSString*)sku;

@end
