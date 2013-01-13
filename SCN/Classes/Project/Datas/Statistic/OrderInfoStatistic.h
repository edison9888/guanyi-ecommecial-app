//
//  OrderInfoStatistic.h
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

@interface OrderInfoStatistic : YK_BaseData {
	NSString* muserid;
	NSString* mdata;
}
@property (nonatomic, retain) NSString* muserid;
@property (nonatomic, retain) NSString* mdata;

-(void)postOrderinfo;
- (void)onPostOrderinfoResponse:(GDataXMLDocument*)xmlDoc;
@end
