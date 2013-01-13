//
//  ProvinceData.h
//  YK_Address
//
//  Created by fan wt on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

/**
    省市区邮编对象
 */
@interface YK_SystemAddressData : YK_BaseData{
	NSString* mparentid; // 父ID
	NSString* mid;       // 自身ID
	NSString* mname;     // 名称
}
@property (nonatomic, strong) NSString* mparentid;
@property (nonatomic, strong) NSString* mid;
@property (nonatomic, strong) NSString* mname;

-(NSString*)showMeYourName:(NSString*)name;
-(void)showArrayIndexOfRow:(int)row;
@end


/**
    从xml数据读取数据存储到sqlite数据库中
 */
@interface YK_ProvinceLoadOperation : NSOperation{
	
}

@end


