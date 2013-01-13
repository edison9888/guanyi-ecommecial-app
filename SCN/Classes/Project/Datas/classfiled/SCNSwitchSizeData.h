//
//  SCNSwitchSizeData.h
//  SCN
//
//  Created by user on 11-10-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
@class size_Data;
@interface SCNSwitchSizeData : NSObject{

    NSMutableArray *m_brandArr;//里面加入brandData
}
+(void)parserXmlDatas:(GDataXMLDocument*)xmlDoc withSwitchSizeData:(SCNSwitchSizeData*)SwitchSizeData;
@property (nonatomic, strong) NSMutableArray *m_brandArr;
@end


@interface brandAndSex_Data : YK_BaseData{
    NSString *mname;
    NSMutableArray *datasArr;//里面加入SexData或size_Data
    NSMutableArray *allSizeArr;//所有尺寸
}
@property (nonatomic, strong) NSString *mname;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) NSMutableArray *allSizeArr;
@end

@interface size_Data : YK_BaseData{
    NSString *mscode;
    
    NSString *msize;
}
@property (nonatomic, strong) NSString *mscode;
@property (nonatomic, strong) NSString *msize;
@end