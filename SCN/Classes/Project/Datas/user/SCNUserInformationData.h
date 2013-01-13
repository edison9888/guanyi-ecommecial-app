//
//  SCNUserData.h
//  SCN
//
//  Created by chenjie on 11-10-11.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

//用户个人资料设置数据
@interface SCNUserInformationData : YK_BaseData {
    NSString* mconsignee;                //收货人姓名;
    NSString* msex;                      //性别;
    NSString* maddressdetail;                  //收货地址;
    NSString* mprovince;                 //省名
    NSString* mcity;                     //市名
    NSString* marea;                     //区名
    NSString* mprovinceId;               //省ID;
    NSString* mcityId;                   //市ID;
    NSString* mareaId;                   //区ID;
    NSString* mtel;                      //固定电话;
    NSString* mphone;                    //手机;
    NSString* mpostcode;                 //邮编;
    NSString* mdefault;                  //默认收货地址 :1表示为默认收货地址 
                                         //             0表示不是默认收货地址;
    NSString* maddressId;                //收货地址ID;
}

@property (nonatomic, strong) NSString* mconsignee;
@property (nonatomic, strong) NSString* msex;
@property (nonatomic, strong) NSString* maddressdetail;
@property (nonatomic, strong) NSString* mprovince;                
@property (nonatomic, strong) NSString* mcity;                    
@property (nonatomic, strong) NSString* marea;                    
@property (nonatomic, strong) NSString* mprovinceId;
@property (nonatomic, strong) NSString* mcityId;
@property (nonatomic, strong) NSString* mareaId;
@property (nonatomic, strong) NSString* mtel;
@property (nonatomic, strong) NSString* mphone;
@property (nonatomic, strong) NSString* mpostcode;
@property (nonatomic, strong) NSString* mdefault;
@property (nonatomic, strong) NSString* maddressId;   

@end
//我的订单
@interface SCNOrderListlData : YK_BaseData {
@private
    NSString* morderId;
    NSString* morderStatus;
    NSString* mtotalMoney;
    NSString* mcreateTime;
    NSString* mnumber;
}
@property (nonatomic ,strong) NSString* morderId;
@property (nonatomic ,strong) NSString* morderStatus;
@property (nonatomic ,strong) NSString* mtotalMoney;
@property (nonatomic ,strong) NSString* mcreateTime;
@property (nonatomic ,strong) NSString* mnumber;
@end
//我的订单pagedata
@interface SCNOrderPageinfoData : YK_BaseData {
    NSString* mpage;
    NSString* mpageSize;
    NSString* mtotalPage;
    NSString* mnumber;
    
}
@property (nonatomic, strong) NSString* mpage;
@property (nonatomic, strong) NSString* mpageSize;
@property (nonatomic, strong) NSString* mtotalPage;
@property (nonatomic, strong) NSString* mnumber;

@end




