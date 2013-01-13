//
//  OffShoppingCartData.h
//  SCN
//
//  Created by huangwei on 11-10-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartData.h"

@interface OffShoppingCartData : CartData {

}

/**
 添加购物车
 @param sku 商品唯一编号
 @param num 数量
 */
+(void)saveWithSku:(NSString*)sku withProductCode:(NSString*)productCode withNumber:(int)num;

+(OffShoppingCartData*)existsInDBWithSku:(NSString*)sku;
+(NSInteger)getOffShoppingCartDataNumberBySku:(NSString*)sku;

@end
