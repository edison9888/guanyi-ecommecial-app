//
//  GY_BaseModel.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseModel.h"

@implementation GY_BaseModel

-(GY_BaseModel*)parseFromJSON:(id)json_data{

    NSString* str_key;
	NSString* str_value;
    
    for (id key in [json_data allKeys]) {
        NSLog(@"%@ - %@",key,[json_data objectForKey:key]);
        
        str_key     = [NSString stringWithFormat:@"setM%@:",(NSString*)key];
		str_value   = [json_data objectForKey:key];
        
        if ([self respondsToSelector:NSSelectorFromString(str_key)])
		{
			[self performSelector:NSSelectorFromString(str_key) withObject:str_value];
		}
    }

	return self;

}


+(NSMutableArray*)parseDataArrayFromJSON:(id)json_data{
    
    NSMutableArray* result_data = [[NSMutableArray alloc]init];
    NSString* str_key;
	NSString* str_value;
    for (id dict in json_data) {
        
        for (id key in [dict allKeys]) {
            
            NSLog(@"%@ - %@",key,[dict objectForKey:key]);
            
            str_key     = [NSString stringWithFormat:@"setM%@:",(NSString*)key];
            str_value   = [dict objectForKey:key];
            
            id model = [[[self class]alloc]init];
            
            if ([model respondsToSelector:NSSelectorFromString(str_key)])
            {
                [model performSelector:NSSelectorFromString(str_key) withObject:str_value];
            }
            [result_data addObject:model];

        }
        
    }
    
	return result_data;
}


@end
