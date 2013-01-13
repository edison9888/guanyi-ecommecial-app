//
//  SCNBrandClassfiledData.h
//  SCN
//
//  Created by yuanli on 11-10-14.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNBrandClassfiledData : NSObject{//品牌浏览图片模式下的数据
    NSMutableArray             *m_brandsArr;
    NSMutableArray             *m_brandIconsArr;
    
    NSMutableArray             *m_allSportsArr;
    NSMutableArray             *m_hotSportsArr;
    
    NSMutableArray             *m_allfemaleShoesArr;
    NSMutableArray             *m_hotfemaleShoesArr;
    
    NSMutableArray             *m_allmaleShoesArr;
    NSMutableArray             *m_hotmaleShoesArr;
}
@property (nonatomic, strong) NSMutableArray             *m_brandsArr;
@property (nonatomic, strong) NSMutableArray             *m_brandIconsArr;

@property (nonatomic, strong) NSMutableArray             *m_allSportsArr;
@property (nonatomic, strong) NSMutableArray             *m_hotSportsArr;

@property (nonatomic, strong) NSMutableArray             *m_allfemaleShoesArr;
@property (nonatomic, strong) NSMutableArray             *m_hotfemaleShoesArr;

@property (nonatomic, strong) NSMutableArray             *m_allmaleShoesArr;
@property (nonatomic, strong) NSMutableArray             *m_hotmaleShoesArr;

@end

@interface brandClassfiledBrandsTagData : YK_BaseData{
    NSString    *mname;
    NSString    *mid;
}
@property (nonatomic, strong) NSString    *mname;
@property (nonatomic, strong) NSString    *mid;
@end


@interface brandClassfiledBrandsData : YK_BaseData{
    NSString    *mimage;
    NSString    *mname;
    NSString    *mbrandId;
    NSString    *mtype;
}
@property (nonatomic, strong) NSString    *mimage;
@property (nonatomic, strong) NSString    *mname;
@property (nonatomic, strong) NSString    *mbrandId;
@property (nonatomic, strong) NSString    *mtype;
@end


