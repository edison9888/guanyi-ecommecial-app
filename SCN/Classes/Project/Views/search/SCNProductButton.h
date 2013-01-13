//
//  SCNProductButton.h
//  SCN
//
//  Created by xie xu on 11-10-18.
//  Copyright 2011年 yek. All rights reserved.
//
//  自定义button用于产品参数的传递
//
#import <UIKit/UIKit.h>

@interface SCNProductButton : UIButton{
    NSString *productCode;
    NSString *sku;
    NSString *imagePath;
    NSString *productTag;
    NSString *pstatus;
    BOOL     isSecEnd;
} 
@property(nonatomic,strong)NSString *productCode;
@property(nonatomic,strong)NSString *sku;
@property(nonatomic,strong)NSString *imagePath;
@property(nonatomic,strong)NSString *productTag;
@property(nonatomic,strong)NSString *pstatus;
@property(nonatomic,assign)BOOL     isSecEnd;
@end
