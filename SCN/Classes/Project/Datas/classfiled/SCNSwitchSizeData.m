//
//  SCNSwitchSizeData.m
//  SCN
//
//  Created by yuanli on 11-10-26.
//  Copyright 2011年 Yek.me. All rights reserved.
//

#import "SCNSwitchSizeData.h"
#import "SCNStatusUtility.h"

@implementation SCNSwitchSizeData
@synthesize m_brandArr;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    m_brandArr = nil;
}
+(void)parserXmlDatas:(GDataXMLDocument*)xmlDoc withSwitchSizeData:(SCNSwitchSizeData*)SwitchSizeData
{
    GDataXMLElement *data_infoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
    
    NSMutableArray *all_BrandArr = [[NSMutableArray alloc]init];//所有品牌
    SwitchSizeData.m_brandArr = all_BrandArr;
    NSArray *brandNodeArr = [data_infoNode nodesForXPath:@"brands/brand" error:nil];
    for (GDataXMLElement *brand  in brandNodeArr) {
        
        brandAndSex_Data *brandData= [[brandAndSex_Data alloc]init];
        [brandData parseFromGDataXMLElement:brand];
        
        NSMutableArray *each_brandDataArr = [[NSMutableArray alloc]init];//不同品牌下对应的性别
        brandData.datasArr = each_brandDataArr;
        
        NSMutableArray *all_SizeArr = [[NSMutableArray alloc]init];//不同品牌下对应的性别
        brandData.allSizeArr = all_SizeArr;
        
        NSArray *sexNodeArr = [brand nodesForXPath:@"sex" error:nil];
        for (GDataXMLElement *sex  in sexNodeArr){
            
            brandAndSex_Data *sexData = [[brandAndSex_Data alloc]init];
            [sexData parseFromGDataXMLElement:sex];
            NSMutableArray *each_sexDataArr = [[NSMutableArray alloc]init];//不同性别下对应的尺寸
            sexData.datasArr = each_sexDataArr;
            
            NSArray *sizeNodeArr = [sex nodesForXPath:@"size" error:nil];
            for (GDataXMLElement *size  in sizeNodeArr){
                size_Data *sizeData = [[size_Data alloc]init];
                [sizeData parseFromGDataXMLElement:size];
                sizeData.msize = [size stringValue];
                [sexData.datasArr addObject:sizeData];
                [brandData.allSizeArr addObject:sizeData];
            }
            [brandData.datasArr addObject:sexData];
        }
        
        [SwitchSizeData.m_brandArr addObject:brandData];
    }

/*    
    NSArray *brandNodeArr = [data_infoNode nodesForXPath:@"brands/brand" error:nil];
    for (GDataXMLElement *brand  in brandNodeArr) {
        NSMutableArray *each_brandDataArr = [[NSMutableArray alloc]init];//不同品牌下对应的性别
        brandAndSex_Data *brandName = [[brandAndSex_Data alloc]init];
        [brandName parseFromGDataXMLElement:brand];
            
           
            NSArray *sexNodeArr = [brand nodesForXPath:@"sex" error:nil];
            for (GDataXMLElement *sex  in sexNodeArr){
                NSMutableArray *each_sexDataArr = [[NSMutableArray alloc]init];//不同性别下对应的尺寸
                brandAndSex_Data *sexName = [[brandAndSex_Data alloc]init];
                [sexName parseFromGDataXMLElement:sex];
                NSArray *sizeNodeArr = [sex nodesForXPath:@"size" error:nil];
                for (GDataXMLElement *size  in sizeNodeArr){
                    size_Data *sizeData = [[size_Data alloc]init];
                    [sizeData parseFromGDataXMLElement:size];
                    sizeData.msize = [size stringValue];
                    [each_sexDataArr addObject:sizeData];
                    [sizeData release];
                }
                NSMutableDictionary *each_sexDic = [[NSMutableDictionary alloc]init];
                if (sexName.mname) {
                    [each_sexDic setObject:each_sexDataArr forKey:sexName.mname];
                }
                [each_sexDataArr release];
                [each_sexDic release];
            }
        
        NSMutableDictionary *single_brandDic = [[NSMutableDictionary alloc]init];
        if (brandName.mname) {
            [single_brandDic setObject:each_brandDataArr forKey:brandName.mname];
        }
        [each_brandDataArr release];
        [SwitchSizeData.m_brandArr addObject:each_brandDataArr];
        [single_brandDic release];
    }
*/
}

@end

@implementation brandAndSex_Data
@synthesize mname,datasArr,allSizeArr;
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
    datasArr = nil;
    allSizeArr = nil;
    
}
@end


@implementation size_Data
@synthesize mscode,msize;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc{
    mscode = nil;
    msize = nil;
}
@end