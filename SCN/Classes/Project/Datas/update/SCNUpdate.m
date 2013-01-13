//
//  SCNUpdate.m
//  SCN
//
//  Created by xie xu on 11-10-24.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNUpdate.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "GY_Constants.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation SCNUpdate

-(void)requestUpdateData{
    /*
     参数名称       描述      是否可为空       样例
     act        对应接口的方法	N           update
     api_version	API版本     N             1.0
     t          客户端时间戳      N           12087021
     weblogid                   N           123123
     ac         数据验证签名      N       POST提交的参数按照字母序升序组合+token，进行MD5加密
     
     client_version	客户端版本号	N	1.0.0/1.1.1
     */
    
    return;
    
    NSString *client_version=[SCNStatusUtility getClientVersion];
    NSDictionary* extraParam = @{@"method": MMUSE_METHOD_GET_UPDATE,
                                @"client_version": client_version};
    [YKHttpAPIHelper startLoadJSON:MMUSE_URL extraParams:extraParam object:self onAction:@selector(onRequestUpdateJSONData:)];
}

-(void)onRequestUpdateJSONData:(id)json_obj
{
        if (![SCNStatusUtility isRequestSuccessJSON:json_obj])
        {
            return;
        }   
        
        NSDictionary* dict = [json_obj objectForKey:@"data"];
    
        self.mprompt=[dict objectForKey:@"msg"] ;
        self.murl=[dict objectForKey:@"url"];
        self.mforceUpdate=[[dict objectForKey:@"force_update"] stringValue];
    
        int need_update = [[dict objectForKey:@"need_update"] intValue];
   
        if (need_update == 1 && self.murl && [self.murl length])
		{
			if ([self.mforceUpdate isEqualToString:@"1"])
			{
				
                [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
                                        message:[NSString stringWithFormat:@"%@", self.mprompt] 
                              cancelButtonTitle:@"升级"];
                
                
			}else{
				
                
                [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
                                        message:[NSString stringWithFormat:@"%@", self.mprompt]
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:[NSArray arrayWithObjects:@"升级", nil]
                                      onDismiss:^(int buttonIndex)
                 {
                     NSLog(@"%d", buttonIndex);
                     NSLog(@"%@",self.murl);
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.murl]];

                 }
                                       onCancel:^()
                 {
                     NSLog(@"Cancelled");
                 }
                 ];

                
                
			}
           
        }
        
   
}


@end
