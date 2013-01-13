//
//  GY_Collection_ProductList.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-8-3.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_ProductList.h"

@implementation GY_Collection_ProductList

-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        _arr_productList                = [self get_arr_object_for_key:@"product_list"];
        _arr_filter_info                = [self get_arr_object_for_key:@"filter"];
    
//        _arr_filter_good_types          = [_arr_filter_info objectForKey:@"good_types"];
//        _dict_filter_brand              = [_arr_filter_info objectForKey:@"brand"];
//        _arr_filter_good_cats           = [_arr_filter_info objectForKey:@"cats"];
//        _arr_filter_good_specs          = [_arr_filter_info objectForKey:@"specs"];
//        _arr_filter_virtual_cats_prices = [_arr_filter_info objectForKey:@"virtual_cats_price"];
//        

    }
    return self;
}





@end
