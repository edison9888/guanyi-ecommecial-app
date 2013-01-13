//
//  SCNSearchData.h
//  SCN
//
//  Created by xie xu on 11-10-10.
//  Copyright 2012年 Guanyi. All rights reserved.
//

#import "YK_BaseData.h"

/**
    关键字数据模型
 */
@interface SCNSearchData : YK_BaseData{
    NSString *mkeyword;
}
@property(nonatomic,strong)NSString *mkeyword;
@end

/**
    搜索结果页面商品列表数据模型
 */
@interface SCNSearchProductListData : YK_BaseData

@property(nonatomic,strong)NSString* mnumber;   //总共商品数
@property(nonatomic,strong)NSString* mkeyword;  //关键字
@property(nonatomic,strong)NSString* mpage;     //当前页码
@property(nonatomic,strong)NSString* mpageSize; //每页数量
@property(nonatomic,strong)NSString* mtotalPage;//总页数
@end

/**
    搜索结果页面商品数据模型
 */
@interface SCNSearchProductData : YK_BaseData 

@property (nonatomic, strong) NSString *mimage;             //图片路径
@property (nonatomic, strong) NSString *mbigImage;          //大图片路径
@property (nonatomic, strong) NSString *mname;              //商品名
@property (nonatomic, strong) NSString *mmarketPrice;       //市场价
@property (nonatomic, strong) NSString *mpstatus;           //商品状态 0:普通 1:下架 2:秒杀 3:库存不足
@property (nonatomic, strong) NSString *msellPrice;         //销售价
@property (nonatomic, strong) NSString *mcomment;           //评论数
@property (nonatomic, strong) NSString *mtag;               //商品标签(热卖|新品,热卖,新品)
@property (nonatomic, strong) NSString *mproductCode;       //商品ID
@property (nonatomic, strong) NSString *mbrand;             //品牌
@property (nonatomic, strong) NSString *mbrandId;           //品牌ID
@property (nonatomic, strong) NSString *mcategoryId;        //分类ID


@end

/*
    商品筛选返回数据
 */
@interface SCNProductFilterItemData : YK_BaseData
@property(nonatomic,strong)NSString *mname;     //条件
@property(nonatomic,strong)NSString *mid;       //条件id
@property(nonatomic,strong)NSString *mcontent;  //类型内容
@property(nonatomic,strong)NSString *mdisplayName;//类型名称
@property(nonatomic,assign)BOOL mselected;      //是否上次被选中
@end
