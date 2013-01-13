//
//  YK_WebDataSource.h
//  YKMAG
//
//  Created by blackApple-1 on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseDataSource.h"
#import "YKHttpRequestHelper+NSString.h"
#import "YKHttpRequest.h"
#import "YK_Params.h"

@interface YK_WebDataSource : YK_BaseDataSource {
	NSURL* m_url;
}
@property (nonatomic,strong) NSURL* m_url;
/**
	初始化DataSource的Url请求
	@param params 需要传递给服务器的参数列表
	@param urlString 需要发送到的url地址
	@returns 返回YK_WebDataSource对象
 */
-(id)initUrlRequest:(YK_Params*)params url:(NSString*)urlString;

@end
