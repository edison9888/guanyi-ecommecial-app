//
//  SCNBrandClassfiledData.m
//  SCN
//
//  Created by yuanli on 11-10-14.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "GY_Model_CategoryBrand.h"

@implementation GY_Model_CategoryBrand
@synthesize m_brandsArr,m_brandIconsArr;
@synthesize m_allSportsArr,m_hotSportsArr,m_allfemaleShoesArr,m_hotfemaleShoesArr,m_allmaleShoesArr,m_hotmaleShoesArr;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    [m_brandsArr release],m_brandsArr = nil;
    [m_brandIconsArr release],m_brandIconsArr = nil;
    
    [m_allSportsArr release],m_allSportsArr = nil;
    [m_hotSportsArr release],m_hotSportsArr = nil;
    [m_allfemaleShoesArr release],m_allfemaleShoesArr = nil;
    [m_hotfemaleShoesArr release],m_hotfemaleShoesArr = nil;
    [m_allmaleShoesArr release],m_allmaleShoesArr = nil;
    [m_hotmaleShoesArr release],m_hotmaleShoesArr = nil;
    
    [super dealloc];
}
@end

@implementation GY_Model_brandClassfiledBrandsTagData
@synthesize mname,mid;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    [mname release],mname = nil;
    [mid release],mid = nil;
    
    [super dealloc];
}
@end

@implementation GY_Model_brandClassfiledBrandsData
@synthesize mimage,mname,mbrandId,mtype;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    [mimage release],mimage = nil;
    [mname release],mname = nil;
    [mbrandId release],mbrandId = nil;
    [mtype release],mtype = nil;
    [super dealloc];
}
@end