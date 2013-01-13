//
//  GY_Collection_Home.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-19.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Home.h"

@implementation GY_Collection_Home



-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        {
            
            self.arr_activity_brands = [self get_arr_object_for_key:@"activity_brands"];
            self.arr_hot_goods = [self get_arr_object_for_key:@"hot_goods"];
            self.arr_recommend_brands = [self get_arr_object_for_key:@"recommend_brands"];
            
            self.str_hot_goods_title = [self.collection_data objectForKey:@"hot_goods_title"];
            self.str_recommend_brands_title = [self.collection_data objectForKey:@"recommend_brands_title"];
            
        }
        
        
    }
    return self;
}

@end
