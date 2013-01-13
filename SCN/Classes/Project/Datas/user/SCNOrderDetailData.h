//
//  SCNOrderDetailData.h
//  SCN
//
//  Created by chenjie on 11-10-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNOrderDetailData : YK_BaseData {
    NSString * morderId;                  //订单id
    NSString * morderStatus;              //订单状态
    NSString * morderTime;                //订单时间
    NSString * mtotalMoney;               //订单总金额
    NSString * mfreight;                  //运费
    NSString * msavePrice;                //优惠金额
    NSString * msavePhonePrice;           //手机下单立减
    NSString * mpayMoney;                 //需付金额
    NSString * mnumber;                   //购买数量
    NSString * maddress;                  //地址
    NSString * mconsignee;                //姓名
    NSString * mphone;                    //手机号
    NSString * mprovince;                 //省
    NSString * mcity;                     //市
    NSString * marea;                     //区
    NSString * mpayType;                  //支付方式
    NSString * mlogisticsTrack;           //物流追踪html信息
    NSString * mmsg;
    
    NSMutableArray * m_mutarray_productlist;  //装载商品信息
    NSMutableArray * m_mutarray_status;
}
@property (nonatomic , strong) NSString * morderId;
@property (nonatomic , strong) NSString * morderStatus;
@property (nonatomic , strong) NSString * morderTime;
@property (nonatomic , strong) NSString * mtotalMoney;
@property (nonatomic , strong) NSString * mfreight;
@property (nonatomic , strong) NSString * msavePrice;
@property (nonatomic , strong) NSString * msavePhonePrice;
@property (nonatomic , strong) NSString * mpayMoney;
@property (nonatomic , strong) NSString * mnumber;
@property (nonatomic , strong) NSString * maddress;
@property (nonatomic , strong) NSString * mconsignee;
@property (nonatomic , strong) NSString * mphone;
@property (nonatomic , strong) NSString * mpayType;
@property (nonatomic , strong) NSString * mlogisticsTrack;
@property (nonatomic , strong) NSString * mprovince;
@property (nonatomic , strong) NSString * mcity;
@property (nonatomic , strong) NSString * marea;
@property (nonatomic , strong) NSString * mmsg;
 
@property (nonatomic , strong) NSMutableArray * m_mutarray_status;
@property (nonatomic , strong) NSMutableArray * m_mutarray_productlist;
@end
@interface SCNOrderProductListData : YK_BaseData {
    
    NSString * mimage;
    NSString * mproductCode;
    NSString * msku;
    NSString * mnumber;
    NSString * mname;
    NSString * msellPrice;
    NSString * mpstatus;
}
@property (nonatomic , strong) NSString * mpstatus;
@property (nonatomic , strong) NSString * mimage;
@property (nonatomic , strong) NSString * mproductCode;
@property (nonatomic , strong) NSString * msku;
@property (nonatomic , strong) NSString * mnumber;
@property (nonatomic , strong) NSString * mname;
@property (nonatomic , strong) NSString * msellPrice;
@end
@interface SCNOrderStatusData : YK_BaseData {

    NSString * mstatus;                    //状态 (订单创建.取消)
    NSString * mtime;                     //时间 (订单创建.取消)

}
@property (nonatomic , strong) NSString * mstatus;
@property (nonatomic , strong) NSString * mtime;
@end