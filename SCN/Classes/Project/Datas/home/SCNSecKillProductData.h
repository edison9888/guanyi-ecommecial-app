//
//  SCNSecKillProductData.h
//  SCN
//
//  Created by xie xu on 11-10-20.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YK_BaseData.h"

typedef enum  
{
    ESeckillWaitting,
    ESeckillRunning,
    ESeckillEnding
}ESeckillStatusEnum;

@interface SCNSecKillProductData : YK_BaseData{
    NSString *mimage;           //商品图片
    NSString *mname;            //商品名
    NSString *mmarketPrice;     //市场价
    NSString *mseckillPrice;    //秒杀价
    NSString *mproductCode;     //商品ID
    NSString *mdiscount;        //折扣
    NSString *mlimit;           //商品剩余
    NSString *mstartTime;       //开始时间
    NSString *mendTime;         //结束时间
	NSString *mpstatus;			//商品状态
    NSTimeInterval mstartTimeInterval;
    NSTimeInterval mendTimeInterval;
    ESeckillStatusEnum mstatus;
}
@property(nonatomic,strong)NSString *mimage;
@property(nonatomic,strong)NSString *mname;
@property(nonatomic,strong)NSString *mmarketPrice;
@property(nonatomic,strong)NSString *mseckillPrice;
@property(nonatomic,strong)NSString *mproductCode;
@property(nonatomic,strong)NSString *mdiscount;
@property(nonatomic,strong)NSString *mlimit;
@property(nonatomic,strong)NSString *mstartTime;
@property(nonatomic,strong)NSString *mendTime;
@property(nonatomic,strong)NSString *mpstatus;
@property(nonatomic,assign)NSTimeInterval mstartTimeInterval;
@property(nonatomic,assign)NSTimeInterval mendTimeInterval;
@property(nonatomic,assign)ESeckillStatusEnum mstatus;
@end
