//
//  GY_Collection_Brands.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-12.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Brands.h"

@implementation GY_Collection_Brands

@synthesize arr_brands_list_view_rows,arr_brands_list_view_sections;

@synthesize arr_brand_icon_female_hot;
@synthesize arr_brand_icon_female_all;
@synthesize arr_brand_icon_male_hot;
@synthesize arr_brand_icon_male_all;
@synthesize arr_brand_icon_outdoor_sport_hot;
@synthesize arr_brand_icon_outdoor_sport_all;


@synthesize arr_brand_icon_hot;
@synthesize arr_brand_icon_all;


-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        arr_brands_list_view_rows     = [NSMutableArray arrayWithCapacity:1];
        
        NSDictionary *data            =  self.collection_data;//super prop
        
        NSDictionary *brand           =  [data objectForKey:@"brand"];
        NSDictionary *brand_icon      =  [data objectForKey:@"brand_icon"];
        
//        {   
//              啰嗦笨蛋写法 这里最好还是交给php来解决json的构造问题
//            //brand
//            arr_brands_list_view_sections = [brand allKeys];//allkeys 返回的是未排序的注意 下面是字母排序
//            arr_brands_list_view_sections = [arr_brands_list_view_sections sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//            
//            for (NSString* tag in arr_brands_list_view_sections){
//                NSMutableArray* brands_group_by_tag = [brand objectForKey:tag];
//                [arr_brands_list_view_rows addObject:brands_group_by_tag];
//                [arr_brands_list_view_rows retain];
//            }
//        }
        {   
              //brand
              arr_brands_list_view_sections = [brand objectForKey:@"sections"];      
              arr_brands_list_view_rows     = [brand objectForKey:@"rows"];//不知道为啥这里一定要加retain才行
        }

        {   
            //brand_icon
            self.arr_brand_icon_female_hot = [brand_icon objectForKey:@"female_hot"];
            self.arr_brand_icon_female_all = [brand_icon objectForKey:@"female_all"];
            self.arr_brand_icon_male_hot = [brand_icon objectForKey:@"male_hot"];
            self.arr_brand_icon_male_all = [brand_icon objectForKey:@"male_all"];
            self.arr_brand_icon_outdoor_sport_hot = [brand_icon objectForKey:@"outdoor_sport_hot"];
            self.arr_brand_icon_outdoor_sport_all = [brand_icon objectForKey:@"outdoor_sport_all"];          
        }
 

    }
    return self;
}



@end
