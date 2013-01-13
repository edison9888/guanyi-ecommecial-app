//
//  SCNRequestResultData.h
//  SCN
//
//  Created by xie xu on 11-10-19.
//  Copyright 2011年 yek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

typedef enum
{
	ERequestSelectNone,
	ERequestSelectConfirm,
	ERequestSelectCancel,
}ERequestSelectState;

@interface SCNRequestResultData : YK_BaseData


@property(nonatomic,strong)NSString *mresult;
@property(nonatomic,strong)NSString *mmsg;
@property(nonatomic,strong)NSString *merror_info;
@property(nonatomic,assign)NSInteger merror_Code;
@property(nonatomic,assign)BOOL	mNoShowTip;                     //不显示业务错误   //	可自定义
@property(nonatomic,assign)BOOL	mNoShowSystemTip;               //不显示系统错误   //	可自定义
@property(nonatomic,assign)ERequestSelectState mSelectConfirm;  //是否确定 0 表示没有选择，1表示确定，2表示取消

-(BOOL)isSuccess;

@end
