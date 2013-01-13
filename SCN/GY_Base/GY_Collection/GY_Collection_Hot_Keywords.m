//
//  GY_Collection_Hot_Keywords.m
//  GuanyiSoft-App
//
//  Created by gakaki on 7/16/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Hot_Keywords.h"

@implementation GY_Collection_Hot_Keywords



-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
  
  
        _arr_hot_keywords = self.collection_data;
        
        if([_arr_hot_keywords count] <=0 ){
            _arr_hot_keywords = [@[] mutableCopy];
        }
        
        
    }
    return self;
}


@end
