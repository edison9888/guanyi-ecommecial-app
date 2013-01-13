//
//  SCNProductDetailData.h
//  SCN
//
//  Created by yuanli on 11-10-12.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
#import "GDataXMLNode.h"

@class skillInfo_Data;
@class productDetail_Data;

@interface SCNProductDetailData : NSObject{//秒杀详情，商品详情公共数据类
    skillInfo_Data          *m_skillInfo_data;
    productDetail_Data      *m_product_data;
    
    NSString                *m_desc;
    NSString                *m_skillDesc;
    NSString                *m_total;//总库存
    
    NSMutableArray          *m_tagsArr;//当前商品类型
    
    NSMutableArray          *m_smallImagesArr;
    NSMutableArray          *m_bigImagesArr;
    
    NSMutableArray          *m_colorArr;
    NSMutableArray          *m_sizeArr;
    NSMutableArray          *m_sharesArr;
}
@property (nonatomic, strong) skillInfo_Data          *m_skillInfo_data;
@property (nonatomic, strong) productDetail_Data      *m_product_data;
@property (nonatomic, strong) NSString                *m_desc;
@property (nonatomic, strong) NSString                *m_skillDesc;
@property (nonatomic, strong) NSString                *m_total;
@property (nonatomic, strong) NSMutableArray          *m_tagsArr;
@property (nonatomic, strong) NSMutableArray          *m_smallImagesArr;
@property (nonatomic, strong) NSMutableArray          *m_bigImagesArr;
@property (nonatomic, strong) NSMutableArray          *m_colorArr;
@property (nonatomic, strong) NSMutableArray          *m_sizeArr;
@property (nonatomic, strong) NSMutableArray          *m_sharesArr;

+(SCNProductDetailData *)parserXmlDatas:(GDataXMLDocument*)xmlDoc IsSkill:(BOOL)iskill;

@end


@interface skillInfo_Data : YK_BaseData{
    NSString *mtitle;
    NSString *mstartTime;
    NSString *mendTime;
    NSString *mdiscount;
    NSString *mlimit;
}
@property (nonatomic, strong) NSString *mtitle;
@property (nonatomic, strong) NSString *mstartTime;
@property (nonatomic, strong) NSString *mendTime;
@property (nonatomic, strong) NSString *mdiscount;
@property (nonatomic, strong) NSString *mlimit;
@end


@interface productDetail_Data : YK_BaseData{
    NSString *mname;
    NSString *msex;
    NSString *mbrand;
    NSString *mpstatus;
    NSString *mtag;
    NSString *mmarketPrice;
    NSString *msellPrice;
    NSString *mbn;
}
@property (nonatomic, strong) NSString *mname;
@property (nonatomic, strong) NSString *msex;
@property (nonatomic, strong) NSString *mbrand;
@property (nonatomic, strong) NSString *mpstatus;
@property (nonatomic, strong) NSString *mtag;
@property (nonatomic, strong) NSString *mmarketPrice;
@property (nonatomic, strong) NSString *msellPrice;
@property (nonatomic, strong) NSString *mbn;
@end

@interface tags_Data : YK_BaseData{
    NSString *mimage;
    
    NSString *minfo;
}
@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *minfo;
@end

@interface images_Data : YK_BaseData{
    NSString *msmallImage;
    NSString *mbigImage;
}
@property (nonatomic, strong) NSString *msmallImage;
@property (nonatomic, strong) NSString *mbigImage;
@end


@interface colors_Data : YK_BaseData{
    NSString *mrgb;
    NSString *mimage;
    NSString *mproductCode;
    NSString *mpstatus;
    NSString *mname;
    NSString *mcheck;
}
@property (nonatomic,strong) NSString *mrgb;
@property (nonatomic,strong) NSString *mimage;
@property (nonatomic,strong) NSString *mproductCode;
@property (nonatomic,strong) NSString *mpstatus;
@property (nonatomic,strong) NSString *mname;
@property (nonatomic,strong) NSString *mcheck;
@end

@interface sizes_Data : YK_BaseData{
    NSString *msku;
    NSString *mstock;
    
    NSString *msize;
}
@property (nonatomic, strong) NSString *msku;
@property (nonatomic, strong) NSString *mstock;
@property (nonatomic, strong) NSString *msize;
@end

@interface shares_Data : YK_BaseData{
    NSString *murl;
    NSString *mimage;
    
    NSString *mname;
}
@property (nonatomic, strong) NSString *murl;
@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *mname;
@end

@interface moreDetailInfo_Data : YK_BaseData{
    NSString *mtitle;
	NSMutableArray  *itemArr;

}
@property (nonatomic, strong) NSString *mtitle;
@property (nonatomic, strong) NSMutableArray  *itemArr;
@end

@interface moreDetailInfo_item_Data : YK_BaseData{
    
    NSString *mname;
    
    NSString *minfo;
}
@property (nonatomic, strong) NSString *mname;
@property (nonatomic, strong) NSString *minfo;
@end

