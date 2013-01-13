//
//  NSMutableDictionary+NSMutableDictUtil.m
//  zxg
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 __Gakaki__. All rights reserved.
//

#import "NSMutableDictionary+NSMutableDictUtil.h"

@implementation NSMutableDictionary (NSMutableDictUtil)

-(BOOL)is_dict_key_empty_or_null:(NSString*)key_name{

    if ([[self allKeys] containsObject:key_name]) {
        id obj = [self objectForKey:key_name];

        if (obj== nil || [@"" isEqualToString:obj] || [obj isKindOfClass:[NSNull class]]) {

            return YES;
        }else{
           
            return NO;
        }

    }

    return YES;

}

-(BOOL)is_exist:(NSString *)key_name{
    return [[self allKeys] containsObject:key_name];
}

@end
