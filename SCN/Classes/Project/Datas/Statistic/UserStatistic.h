//
//  UserStatistic.h
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

@interface UserStatistic : YK_BaseData {
	NSString* musername;
	NSString* muserid;
}
@property (nonatomic, retain) NSString* musername;
@property (nonatomic, retain) NSString* muserid;

-(void)postClientinfo;
-(void)onPostClientinfoResponse:(GDataXMLDocument*)xmlDoc;
@end



@interface UserFeedback	: YK_BaseData {
	NSString* mresult;
	NSString* msessionid;
	NSString* mdesc;
}
@property(nonatomic,retain)NSString* mresult;
@property(nonatomic,retain)NSString* msessionid;
@property(nonatomic,retain)NSString* mdesc;

+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc;
@end