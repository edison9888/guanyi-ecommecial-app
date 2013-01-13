//
//  NSMutableDictionary+NSMutableDictUtil.h
//  zxg
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 __Gakaki__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NSMutableDictUtil)

-(BOOL)is_dict_key_empty_or_null:(NSString*)key_name;
-(BOOL)is_exist:(NSString*)key_name;


@end


//    if( [json_obj isKindOfClass:[NSArray class]] || [json_obj isKindOfClass:[NSMutableArray class]]){
//        //Is array
//
//    }else if( [json_obj isKindOfClass:[NSDictionary class]] || [json_obj isKindOfClass:[NSMutableDictionary class]] ){
//        //is dictionary
//
//    }else{
//        //is something else
//
//    }