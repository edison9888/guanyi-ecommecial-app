//
//  GY_Collection_Filter_Keywords.m
//  GuanyiSoft-App
//
//  Created by gakaki on 7/16/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Filter_Keywords.h"

@implementation GY_Collection_Filter_Keywords

-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        _arr_filter_keywords = self.collection_data;
        
        if([_arr_filter_keywords count] <=0 ){
            _arr_filter_keywords = [@[] mutableCopy];
        }

        
    }
    return self;
}


@end
