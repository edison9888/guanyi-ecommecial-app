//
//  YKHttpRequestHelper+NSString.h
//  YKMAG
//
//  Created by guwei ZZZ on 11-7-18.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKHttpRequest.h"

@interface YKHttpRequestHelper_NSString : NSObject<YKHttpRequestDelegate> {
	id object;
	SEL action;
}
/*
 object:
 网址内容下载完成后调用此对象的action方法，action方法格式同下
 action:
 -(void) ****:(GDataXMLDocument*) xmlDoc params:(NSDictionary*) params ;
 
 */
-(id) initWithObject:(id)aobj action:(SEL)aaction;

@end
