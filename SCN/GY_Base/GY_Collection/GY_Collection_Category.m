//
//  GY_Collection_Category.m
//  GuanyiSoft-App
//
//  Created by gakaki on 7/17/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Category.h"

@implementation GY_Collection_Category

-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        _arr_dict_categories = self.collection_data;
        
        if([_arr_dict_categories count] <=0 ){
            _arr_dict_categories = [@[] mutableCopy];
        }
        
    }
    return self;
}



@end
