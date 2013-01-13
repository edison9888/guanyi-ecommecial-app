//
//  GY_Collection_Home.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-19.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_Home : GY_BaseCollection


@property (nonatomic, strong) NSMutableArray  *arr_activity_brands;
@property (nonatomic, strong) NSMutableArray  *arr_hot_goods;
@property (nonatomic, strong) NSMutableArray  *arr_recommend_brands;

@property (nonatomic, strong) NSString*  str_hot_goods_title;
@property (nonatomic, strong) NSString*  str_recommend_brands_title;

-(id)initWithJSON:(id)json_object;

@end
