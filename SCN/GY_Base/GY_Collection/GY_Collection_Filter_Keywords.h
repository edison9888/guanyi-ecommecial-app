//
//  GY_Collection_Filter_Keywords.h
//  GuanyiSoft-App
//
//  Created by gakaki on 7/16/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_Filter_Keywords : GY_BaseCollection

@property (nonatomic, strong) NSMutableArray  *arr_filter_keywords;

-(id)initWithJSON:(id)json_object;

@end
