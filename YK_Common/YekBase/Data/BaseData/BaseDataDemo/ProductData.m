//
//  ProductData.m
//  BaseDataDemo
//
//  Created by wtfan on 11-11-11.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "ProductData.h"

@implementation ProductData

@synthesize mproduct_id;
@synthesize mproduct_name;
@synthesize mlist_price;
@synthesize mshelf_price;
@synthesize mimage_s_path;
@synthesize maaa;

-(void)dealloc{
    self.mproduct_id = nil;
    self.mproduct_name = nil;
    self.mlist_price = nil;
    self.mshelf_price = nil;
    self.mimage_s_path = nil;
    self.maaa = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"<%d> id:%@, name:%@, price:%@, path:%@",
            mproduct_id, mproduct_name, mlist_price, mshelf_price, mimage_s_path];
}

@end
