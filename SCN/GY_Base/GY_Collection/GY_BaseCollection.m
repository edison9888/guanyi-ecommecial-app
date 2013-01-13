//
//  GY_BaseCollection.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-12.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@implementation GY_BaseCollection

-(NSMutableArray*)get_array_init:(id)json_object withKey:(NSString*)key_name{
    
    NSMutableArray* v = [json_object objectForKey:key_name];
    
    if(!v ){
        v = [@[] mutableCopy];
    }
    return v;
}
-(NSMutableArray*)get_arr_object_for_key:(NSString*)key_name{
    
    id tmp = [self.collection_data valueForKey:key_name];
    if ( tmp == [NSNull null] || tmp == Nil || tmp == NULL)
    {
        tmp = [@[] mutableCopy];
    }
    return tmp;
}

-(id)get_string_value_init_for_key:(NSString*)key_name{
    id tmp = [self.collection_data valueForKey:key_name];
    if ( tmp == [NSNull null] || tmp == Nil )
    {
        tmp = @"";
    }
    return tmp;
}


-(id)initWithJSON:(id)json_object{
    
    self = [super init];
    if(self) {
        
        self.json_data = json_object;
        NSDictionary* json_dict = (NSDictionary*)self.json_data;
        
        self.collection_data = [json_dict valueForKey:@"data"];
        
        //若为空那么初始化一下免得问题
        if(self.collection_data == NULL && [self.collection_data count] <=0 ){
            self.collection_data = [@[] mutableCopy];
        }
        
        self.count = (NSUInteger)[json_dict objectForKey:@"count"];
        self.total = (NSUInteger)[json_dict objectForKey:@"total"];
        self.page  = (NSUInteger)[json_dict objectForKey:@"page"];
        self.page_size = (NSUInteger)[json_dict objectForKey:@"page_size"];
        self.total_page = (NSUInteger)[json_dict objectForKey:@"total_page"];

        self.status = (NSString*)[json_dict objectForKey:@"status"];
        self.msg = (NSString*)[json_dict objectForKey:@"msg"];
        self.ts = (NSString*)[json_dict objectForKey:@"ts"];
        
        
    }
    return self;
}

@end
