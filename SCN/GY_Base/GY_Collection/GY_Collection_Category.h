//
//  GY_Collection_Category.h
//  GuanyiSoft-App
//
//  Created by gakaki on 7/17/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_Category : GY_BaseCollection

@property (nonatomic, strong) NSMutableArray  *arr_dict_categories;

-(id)initWithJSON:(id)json_object;


@end
