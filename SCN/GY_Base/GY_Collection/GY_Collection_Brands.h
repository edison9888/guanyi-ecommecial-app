//
//  GY_Collection_Brands.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-12.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_Brands : GY_BaseCollection

@property (nonatomic, strong) NSArray  *arr_brands_list_view_sections;
@property (nonatomic, strong) NSMutableArray  *arr_brands_list_view_rows;

@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_outdoor_sport_hot;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_outdoor_sport_all;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_female_hot;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_female_all;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_male_hot;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_male_all;

@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_hot;
@property (nonatomic, strong) NSMutableArray  *arr_brand_icon_all;


-(id)initWithJSON:(id)json_object;


@end
