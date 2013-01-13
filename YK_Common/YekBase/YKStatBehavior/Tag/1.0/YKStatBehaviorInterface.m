//
//  YKStatBehaviorInterface.m
//  Moonbasa
//
//  Created by zhi.zhu on 11-9-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YKStatBehaviorInterface.h"
#import "YKGo2PageConfigLoader.h"
#import "YKStatBehavior.h"

@interface YKStatBehaviorInterface(PrivateMethod)
+(NSString *)getFilePath:(NSString *)fileName;
@end
/**
 用户操作ID
 */
const int YK_STATBEHAVIOR_OPERATION_CLICK = 1018;//用户点击
const int YK_STATBEHAVIOR_OPERATION_ADD_TO_SHOPPINGCART = 1003;//加入购物车
const int YK_STATBEHAVIOR_OPERATION_ADD_TO_FAVOURITE = 1005;//加入收藏夹
const int YK_STATBEHAVIOR_OPERATION_SUBMITORDER_FAIlED = 1008;//提交订单失败
const int YK_STATBEHAVIOR_OPERATION_SUBMITORDER_SUCCESS = 1007;//提交订单成功

NSInteger currentPageId = 1001;
NSInteger currentSourcePageId = 0;

@implementation YKStatBehaviorInterface

#pragma mark - 提交统计数据
/*
 额外参数:以以下名字为key的字典（任何一项都不能为空）:
 //用于http头
 productcode：应用程序名字
 appversion：客户端版本号
 sourcesubid：子渠道号
 
 //其他
 appname：应用名称,Vancl,Vjia等
 sourceid：渠道号,Yek_001等
 isrealurl：是否是真实服务器，返回@"YES",使用真实服务器，返回@"NO"使用测试服务器，默认使用真实服务器（如果不提供此函数）
 */
// 启动行为统计
+(BOOL)start:(NSDictionary*)extraParams
{
    return [YKStatBehavioEngine start:extraParams]; 
}

// 重置行为统计模块，重新获取时间戳，当程序切换到后台，又切回来时调用
+(BOOL)reset
{
    return [YKStatBehavioEngine reset];
}

// 程序启动    runNum:启动次数，version:app版本号
+(BOOL)logEvent_AppStartupWithRunNum:(NSInteger)runNum version:(NSString *)version
{
    return [YKStatBehavioEngine logEvent_AppStartup:currentPageId runNum:runNum version:version];
}

// 程序状态变化   state:状态 0异常、1后台、2前台
+(BOOL)logEvent_StateChange:(NSInteger)state
{
    return [YKStatBehavioEngine logEvent_StateChange:currentPageId state:state];
}

// 程序退出     state:0异常、1正常
+(BOOL)logEvent_AppExit:(NSInteger)state
{
    return [YKStatBehavioEngine logEvent_AppExit:currentPageId state:state];
}

// 页面跳转     pageId:目的页面的id  param:辅助参数
+(BOOL)logEvent_PageJumpWithAimPath:(NSString *)aimPath param:(NSString *)param
{
    // yh 2011.11.18
    if ([[YKGo2PageConfigLoader instance] getBIPageIdWithPath:aimPath] == nil) {
        return NO;
    }
    //
    
    NSInteger aimPageId = [[[YKGo2PageConfigLoader instance] getBIPageIdWithPath:aimPath] intValue];

    NSLog(@"PageJump :  %d  %d  %@",currentPageId,aimPageId,param);
    BOOL result = [YKStatBehavioEngine logEvent_PageJump:currentPageId aimPageId:aimPageId param:param];
    if ([[[YKGo2PageConfigLoader instance] getBIIsSourceWithPath:aimPath] isEqualToString:@"1"]) {
        currentSourcePageId = aimPageId;
    }
    currentPageId = aimPageId;
    return result;
}
+(BOOL)logEvent_PageJumpWithAimPath:(NSString *)aimPath paramObject:(id)pObject
{
    // yh 2011.11.18
    if ([[YKGo2PageConfigLoader instance] getBIPageIdWithPath:aimPath] == nil) {
        return NO;
    }
    //
    
    NSInteger aimPageId = [[[YKGo2PageConfigLoader instance] getBIPageIdWithPath:aimPath] intValue];
    NSString *param = @"";
    
    NSString *sel_param = [[YKGo2PageConfigLoader instance] getBIParamSelectorStrWithPath:aimPath];
    
    if (sel_param != nil && [[sel_param stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0) {
        SEL sel = NSSelectorFromString(sel_param);
        assert([pObject respondsToSelector:sel] == YES);//配置了获取参数的回调方法,则必须被实现
        param = [pObject performSelector:sel];
        param = param==nil?@"":param;
    }
    NSLog(@"PageJump :  %d  %d  %@",currentPageId,aimPageId,param);
    
    BOOL result = [YKStatBehavioEngine logEvent_PageJump:currentPageId aimPageId:aimPageId param:param];
    if ([[[YKGo2PageConfigLoader instance] getBIIsSourceWithPath:aimPath] isEqualToString:@"1"]) {
        currentSourcePageId = aimPageId;
    }
    currentPageId = aimPageId;
    return result;
}

// 用户操作     operateId:操作id  param:辅助参数
+(BOOL)logEvent_OperateWithOperateId:(NSInteger)operateId param:(NSString *)param
{
    NSLog(@"Operate : %d  %d     %@",currentPageId,operateId,param);
    return [YKStatBehavioEngine logEvent_Operate:currentPageId operateId:operateId param:param];
}

// 扩展指令     extendId:扩展事件id   param:辅助参数
+(BOOL)logEvent_ExtendEventWithExtendId:(NSInteger)extendId param:(NSString *)param
{
    return [YKStatBehavioEngine logEvent_ExtendEvent:currentPageId extendId:extendId param:param];
}
#pragma mark -
+(NSInteger)currentSourcePageId
{
    return currentSourcePageId;
}

+(NSString *)getFilePath:(NSString *)fileName
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSAllDomainsMask,YES);
    
    int pathLen = [pathArray count];
    NSLog(@"path number is :%d",pathLen);
    
    NSString *filePath = nil;
    
    for(int i = 0; i < pathLen; i++)
    {
        filePath = [pathArray objectAtIndex:i];
        
        NSLog(@"%d path is :%@",i,filePath);
    }
    
    NSString *myFilename = [filePath stringByAppendingPathComponent:fileName];
    
    NSLog(@"myfile\'s path is :%@",myFilename);
    return myFilename;
}
+(BOOL)saveSourcePageId:(NSInteger)sourcePageId withSku:(NSString *)sku
{
    NSString *myFilename = [[self class] getFilePath:@"sourcePageIdMap.rtf"];

    // unarchive
    NSDictionary *dict_sourcePageIdMap = [NSKeyedUnarchiver unarchiveObjectWithFile:myFilename];
    NSMutableDictionary *temp_dict = nil;
    if (dict_sourcePageIdMap == nil) {
        temp_dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    else
    {
        temp_dict = [NSMutableDictionary dictionaryWithDictionary:dict_sourcePageIdMap];
    }
    [temp_dict setObject:@(sourcePageId) forKey:sku];
    
    [NSKeyedArchiver archiveRootObject:temp_dict toFile:myFilename];
    return YES;
}

+(NSInteger)sourcePageIdWithSku:(NSString *)sku
{
    NSInteger ret_pageId = -1;
    NSString *myFilename = [[self class] getFilePath:@"sourcePageIdMap.rtf"];
    NSDictionary *dict_sourcePageIdMap = [NSKeyedUnarchiver unarchiveObjectWithFile:myFilename];
    if (dict_sourcePageIdMap != nil) {
        NSNumber *pageId = [dict_sourcePageIdMap objectForKey:sku];
        ret_pageId = pageId != nil? [pageId intValue] : -1;
    }
    return ret_pageId;
}

+(BOOL)clearSourcePageIdWithSku:(NSString *)sku
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict_sourcePageIdMap = [saveDefaults objectForKey:@"sourcePageIdMap"];
    if (dict_sourcePageIdMap != nil) {
        [dict_sourcePageIdMap removeObjectForKey:sku];
    }
    return YES;
}

+(BOOL)clearAllSourcePageId
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict_sourcePageIdMap = [saveDefaults objectForKey:@"sourcePageIdMap"];
    if (dict_sourcePageIdMap != nil) {
        [dict_sourcePageIdMap removeAllObjects];
    }
    return YES;
}

@end
