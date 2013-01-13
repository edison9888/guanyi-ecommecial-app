//
//  YK_BkStat_Order.h
//  Benefit
//
//  Created by Liu Yuhui on 11-9-20.
//  Copyright 2011年 YeKe.com. All rights reserved.
//
//  订单item,要发送的订单详情先缓存到本地，成功发送后再清除缓存

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"


@interface YK_BkStat_Order : SQLitePersistentObject {
    
}

@property(nonatomic,strong)NSString*    orderid;
@property(nonatomic,strong)NSString*    username;
@property(nonatomic,strong)NSString*    fullname;
@property(nonatomic,strong)NSString*    cellphone;
@property(nonatomic,strong)NSString*    province;
@property(nonatomic,strong)NSString*    city;
@property(nonatomic,strong)NSString*    county;
@property(nonatomic,strong)NSString*    address;
@property(nonatomic,strong)NSString*    amount;
@property(nonatomic,strong)NSString*    ordertime;
@property(nonatomic,strong)NSString*    itemdata;

-(id)initWithDictionary:(NSDictionary*)aDic;    // 用字典对象初始化
-(NSDictionary*)dictionary;                     // 将对象转换为字典

@end

