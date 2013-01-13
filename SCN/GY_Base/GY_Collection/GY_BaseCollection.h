//
//  GY_BaseCollection.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-6-12.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface GY_BaseCollection : NSObject

@property (nonatomic, strong) id  json_data;
@property (nonatomic, strong) id  collection_data;


@property (nonatomic, assign) NSUInteger  count;
@property (nonatomic, assign) NSUInteger  total;
@property (nonatomic, assign) NSUInteger  page;
@property (nonatomic, assign) NSUInteger  page_size;
@property (nonatomic, assign) NSUInteger  total_page;

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* msg;
@property (nonatomic, strong) NSString* ts;


-(id)get_spec_key_init:(id)json_object withKey:(NSString*)key_name;
-(NSMutableArray*)get_arr_object_for_key:(NSString*)key_name;

-(id)get_string_value_init_for_key:(NSString*)key_name; //若key对象为中文 那么使用nsstring 初始化

-(id)initWithJSON:(id)json_object;

@end
