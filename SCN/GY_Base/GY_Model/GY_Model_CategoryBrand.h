//
//  GY_Model_Category.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GY_BaseModel.h"

@interface GY_Model_CategoryBrand : NSObject
 

@property (nonatomic, retain) NSMutableArray             *m_brandsArr;
@property (nonatomic, retain) NSMutableArray             *m_brandIconsArr;

@property (nonatomic, retain) NSMutableArray             *m_allSportsArr;
@property (nonatomic, retain) NSMutableArray             *m_hotSportsArr;

@property (nonatomic, retain) NSMutableArray             *m_allfemaleShoesArr;
@property (nonatomic, retain) NSMutableArray             *m_hotfemaleShoesArr;

@property (nonatomic, retain) NSMutableArray             *m_allmaleShoesArr;
@property (nonatomic, retain) NSMutableArray             *m_hotmaleShoesArr;

@end


@interface GY_Model_brandClassfiledBrandsTagData : GY_BaseModel{

@property (nonatomic, retain) NSString    *mname;
@property (nonatomic, retain) NSString    *mid;
@end


    
    
    
@interface GY_Model_brandClassfiledBrandsData : GY_BaseModel{

@property (nonatomic, retain) NSString    *mimage;
@property (nonatomic, retain) NSString    *mname;
@property (nonatomic, retain) NSString    *mbrandId;
@property (nonatomic, retain) NSString    *mtype;


@end
