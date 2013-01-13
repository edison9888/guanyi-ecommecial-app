//
//  SCNProductDetailData.m
//  SCN
//
//  Created by yuanli on 11-10-12.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNProductDetailData.h"
#import "SCNStatusUtility.h"

@implementation SCNProductDetailData
@synthesize  m_skillInfo_data,m_product_data;
@synthesize m_desc,m_skillDesc,m_total;
@synthesize m_tagsArr,m_smallImagesArr,m_bigImagesArr,m_colorArr,m_sizeArr,m_sharesArr;

//-(void)setM_colorArr:(NSMutableArray *)arr
//{
//	[arr retain];
//	[m_colorArr release];
//	m_colorArr = arr;
//}
//
//-(NSMutableArray*)m_colorArr
//{
//	return m_colorArr;
//}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc
{
    m_skillInfo_data = nil;
    m_product_data = nil;
    m_desc = nil;
    m_skillDesc = nil;
    m_total = nil;
    m_tagsArr = nil;
    m_smallImagesArr = nil;
    m_bigImagesArr = nil;
    m_colorArr = nil;
    m_sizeArr = nil;
    m_sharesArr = nil;
}

+(SCNProductDetailData *)parserXmlDatas:(GDataXMLDocument*)xmlDoc IsSkill:(BOOL)iskill
{
	SCNProductDetailData   *productDetailDatas =[[SCNProductDetailData alloc]init];
    GDataXMLElement *data_infoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
    if (iskill==YES) 
	{
		//秒杀类商品信息
//        NSString *seckillInfoPath = [NSString stringWithFormat:@"shopex/info/data_info/seckillInfo"];
        GDataXMLElement *seckillInfoNode = [data_infoNode oneElementForName:@"seckillInfo"];
        skillInfo_Data *skill_Data = [[skillInfo_Data alloc]init];
        [skill_Data parseFromGDataXMLElement:seckillInfoNode];
        productDetailDatas.m_skillInfo_data = skill_Data;
        
        GDataXMLElement *seckillDetailNode = [data_infoNode oneElementForName:@"seckilldetail"];
        productDetailDatas.m_skillDesc = [seckillDetailNode stringValue];
        
    }
    else
    {
        NSArray  *tagsNodeArr = [data_infoNode nodesForXPath:@"tags/tag" error:nil];
        
        NSMutableArray *tagsArr = [[NSMutableArray alloc]init];
        productDetailDatas.m_tagsArr = tagsArr;
        
        if ([tagsNodeArr count]>0) {
            for (GDataXMLElement *tag  in tagsNodeArr) {
                tags_Data *tag_Data = [[tags_Data alloc]init];
                [tag_Data parseFromGDataXMLElement:tag];
                tag_Data.minfo = [tag stringValue];
                [productDetailDatas.m_tagsArr addObject:tag_Data];
            }
        }
    }
//非秒杀类商品信息
/*-----------------------解析商品信息----------------------*/
        GDataXMLElement *productNode = [data_infoNode oneElementForName:@"product"];
        productDetail_Data *product_Data = [[productDetail_Data alloc]init];
        [product_Data parseFromGDataXMLElement:productNode];
        productDetailDatas.m_product_data = product_Data;
/*-----------------------解析商品描述----------------------*/
        GDataXMLElement *descNode = [data_infoNode oneElementForName:@"desc"];
        productDetailDatas.m_desc = [descNode stringValue];
/*-----------------------解析图片----------------------*/
        NSArray  *imagesNodeArr = [data_infoNode nodesForXPath:@"images/image" error:nil];
        
        NSMutableArray *smallImagesArr = [[NSMutableArray alloc]init];
        productDetailDatas.m_smallImagesArr = smallImagesArr;
        
        NSMutableArray *bigImagesArr = [[NSMutableArray alloc]init];
        productDetailDatas.m_bigImagesArr = bigImagesArr;
        
        if ([imagesNodeArr count]>0) {
            for (GDataXMLElement *images in imagesNodeArr) {
                images_Data *img_Data = [[images_Data alloc]init];
                [img_Data parseFromGDataXMLElement:images];
                if (img_Data.msmallImage) {
                    [productDetailDatas.m_smallImagesArr addObject:img_Data.msmallImage];
                }
                if (img_Data.mbigImage) {
                [productDetailDatas.m_bigImagesArr addObject:img_Data.mbigImage];
                }
            }

        }
        
/*-----------------------解析颜色信息----------------------*/
    NSArray  *colorsNodeArr = [data_infoNode nodesForXPath:@"colors/color" error:nil];
    
    NSMutableArray *colorsArr = [[NSMutableArray alloc]init];
    productDetailDatas.m_colorArr = colorsArr;
    
    if ([colorsNodeArr count]>0) {
        for (GDataXMLElement *color in colorsNodeArr) {
            colors_Data *color_Data = [[colors_Data alloc]init];
            [color_Data parseFromGDataXMLElement:color];
            [productDetailDatas.m_colorArr addObject:color_Data];
        }
        
    }
/*-----------------------解析尺码信息----------------------*/
    NSArray  *sizesNodeArr = [data_infoNode nodesForXPath:@"sizes/size" error:nil];
    
    NSMutableArray *sizeArr = [[NSMutableArray alloc]init];
    productDetailDatas.m_sizeArr = sizeArr;
    
    if ([sizesNodeArr count]>0) {
        int total = 0;
        for (GDataXMLElement *size in sizesNodeArr) {
            sizes_Data *size_Data = [[sizes_Data alloc]init];
            [size_Data parseFromGDataXMLElement:size];
            total = total + [size_Data.mstock intValue];
            size_Data.msize = [size stringValue];
            if (iskill && [size_Data.mstock intValue]>0) 
            {
                [productDetailDatas.m_sizeArr addObject:size_Data];
            }
            else
            {
                [productDetailDatas.m_sizeArr addObject:size_Data];
            }
            
            
            
        }
        productDetailDatas.m_total = [NSString stringWithFormat:@"%d",total];
    }
    
/*-----------------------解析分享信息----------------------*/
    NSArray  *sharesNodeArr = [data_infoNode nodesForXPath:@"shares/share" error:nil];
    
    NSMutableArray *shareArr = [[NSMutableArray alloc]init];
    productDetailDatas.m_sharesArr = shareArr;
    
    if ([sharesNodeArr count]>0) {
        for (GDataXMLElement *share in sharesNodeArr) {
            shares_Data *share_Data = [[shares_Data alloc]init];
            [share_Data parseFromGDataXMLElement:share];
            share_Data.murl = [share stringValue];
            [productDetailDatas.m_sharesArr addObject:share_Data];
        }
        
    }
	
    return productDetailDatas;
}

@end


@implementation skillInfo_Data
@synthesize mtitle,mstartTime,mendTime,mdiscount,mlimit;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mtitle = nil;
    mstartTime = nil;
    mendTime = nil;
    mdiscount = nil;
    mlimit = nil;
}
@end


@implementation productDetail_Data
@synthesize mname,msex,mbrand,mpstatus,mtag,mmarketPrice,msellPrice,mbn;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mname = nil;
    msex = nil;
    mbrand = nil;
    mpstatus = nil;
    mtag = nil;
    mmarketPrice = nil;
    msellPrice = nil;
    mbn = nil;
}
@end

@implementation tags_Data
@synthesize mimage,minfo;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mimage = nil;
    minfo = nil;
}
@end

@implementation images_Data
@synthesize msmallImage,mbigImage;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    msmallImage = nil;
    mbigImage = nil;
}
@end


@implementation colors_Data
@synthesize mrgb,mimage,mproductCode,mpstatus,mname,mcheck;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mrgb = nil;
    mimage = nil;
    mproductCode = nil;
    mpstatus = nil;
    mname = nil;
    mcheck = nil;
}
@end


@implementation sizes_Data
@synthesize msku,mstock,msize;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    msku = nil;
    mstock = nil;
    msize = nil;
}
@end



@implementation shares_Data
@synthesize murl,mimage,mname;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    murl = nil;
    mimage = nil;
    mname = nil;
}
@end


@implementation moreDetailInfo_Data
@synthesize mtitle,itemArr;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mtitle = nil;
    itemArr = nil;
}
@end

@implementation moreDetailInfo_item_Data
@synthesize mname,minfo;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)dealloc
{
    mname = nil;
    minfo = nil;
}
@end