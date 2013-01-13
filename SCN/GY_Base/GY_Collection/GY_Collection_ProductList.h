//
//  GY_Collection_ProductList.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-8-3.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_ProductList : GY_BaseCollection

@property (nonatomic, strong) NSMutableArray        *arr_productList;       //产品列表
@property (nonatomic, strong) NSMutableArray        *arr_filter_info;      //商品的筛选信息

@property (nonatomic, strong) NSMutableArray        *arr_filter_good_types; //商品类型
@property (nonatomic, strong) NSMutableDictionary   *dict_filter_brand;     //商品品牌
@property (nonatomic, strong) NSMutableArray        *arr_filter_good_cats;  //商品分类


@property (nonatomic, strong) NSMutableArray        *arr_filter_good_specs; //商品规格
@property (nonatomic, strong) NSMutableArray        *arr_filter_virtual_cats_prices; //商品价格区间 对应后台虚拟分类


-(id)initWithJSON:(id)json_object;

@end
