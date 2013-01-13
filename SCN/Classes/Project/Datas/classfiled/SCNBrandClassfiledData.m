//
//  SCNBrandClassfiledData.m
//  SCN
//
//  Created by yuanli on 11-10-14.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNBrandClassfiledData.h"

@implementation SCNBrandClassfiledData
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
    m_brandsArr = nil;
    m_brandIconsArr = nil;
    
    m_allSportsArr = nil;
    m_hotSportsArr = nil;
    m_allfemaleShoesArr = nil;
    m_hotfemaleShoesArr = nil;
    m_allmaleShoesArr = nil;
    m_hotmaleShoesArr = nil;
    
}
@end

@implementation brandClassfiledBrandsTagData
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
    mname = nil;
    mid = nil;
    
}
@end

@implementation brandClassfiledBrandsData
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
    mimage = nil;
    mname = nil;
    mbrandId = nil;
    mtype = nil;
    
}
@end