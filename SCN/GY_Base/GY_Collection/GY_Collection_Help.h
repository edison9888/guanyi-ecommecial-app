//
//  GY_Collection_Help.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-7-21.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "GY_BaseCollection.h"

@interface GY_Collection_Help : GY_BaseCollection

@property (nonatomic, strong) NSMutableArray  *arr_dict_help_infos;

-(id)initWithJSON:(id)json_object;

@end
