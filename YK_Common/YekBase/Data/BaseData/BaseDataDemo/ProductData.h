//
//  ProductData.h
//  BaseDataDemo
//
//  Created by wtfan on 11-11-11.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"
//
//<product_id>00054166</product_id> \
//<product_name>【Epin】亿品秋冬新款女装韩版淑女长袖修身连衣裙（黑色）</product_name> \
//<list_price>179.0</list_price> \
//<shelf_price>79.0</shelf_price> \
//<image_s_path>

@interface ProductData : YK_BaseData{
    NSString* mproduct_id;
    NSString* mproduct_name;
    NSString* mlist_price;
    NSString* mshelf_price;
    NSString* mimage_s_path;
    NSString* maaa;
}
@property (nonatomic, retain) NSString* mproduct_id;
@property (nonatomic, retain) NSString* mproduct_name;
@property (nonatomic, retain) NSString* mlist_price;
@property (nonatomic, retain) NSString* mshelf_price;
@property (nonatomic, retain) NSString* mimage_s_path;
@property (nonatomic, retain) NSString* maaa;

@end
