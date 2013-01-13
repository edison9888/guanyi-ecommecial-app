//
//  GY_Collection_Help.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-7-21.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_Collection_Help.h"

@implementation GY_Collection_Help

-(id)initWithJSON:(id)json_object{
    
    self = [super initWithJSON:json_object];
    if(self) {
        
        self.arr_dict_help_infos = self.collection_data;
    }
    return self;
}



@end
