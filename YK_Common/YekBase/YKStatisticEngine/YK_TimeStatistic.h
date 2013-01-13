//
//  YK_TimeStatistic.h
//  Moonbasa
//
//  Created by wtfan on 11-9-20.
//  Copyright 2011年 Yek. All rights reserved.
//  
//  获取服务器的时间戳（从1970开始的秒数）
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

#import "ASIHTTPRequest.h"

@protocol YK_TimeStatisticDelegate <NSObject>

@optional
-(void)onRequestTimeStatisticFailed:(ASIHTTPRequest*)request;

@required
-(void)onRequestTimeStatisticFinished:(NSString*)timeStr;

@end


@interface YK_TimeStatistic : YK_BaseData{
    id<YK_TimeStatisticDelegate> __unsafe_unretained delegate;
    
    NSString* mresult;
    NSString* mdesc;
    NSString* mtime;
}
@property(nonatomic, unsafe_unretained) id<YK_TimeStatisticDelegate> delegate;

@property(nonatomic, strong) NSString* mresult;
@property(nonatomic, strong) NSString* mdesc;
@property(nonatomic, strong) NSString* mtime;

/**
    获取服务器时间戳
 */
-(void)postTimeRequest;

@end
