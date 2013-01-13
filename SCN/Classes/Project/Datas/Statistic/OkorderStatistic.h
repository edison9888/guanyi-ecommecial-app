//
//  OkorderStatistic.h
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

@interface OkorderStatistic : YK_BaseData {
	NSString* mproductcode;
	NSString* morderid;
	NSString* msessionid;
	NSString* mordermessage;
	NSString* muserid;
	NSString* musername;
	NSString* mfullname;
	NSString* mcellphone;
	NSString* mprovince;
	NSString* mcity;
	NSString* mcounty;
	NSString* maddress;
	NSString* mamount;
	NSString* mordertime;
	NSString* mitemdata;
}
@property (nonatomic, retain) NSString* mproductcode;
@property (nonatomic, retain) NSString* morderid;
@property (nonatomic, retain) NSString* msessionid;
@property (nonatomic, retain) NSString* mordermessage;
@property (nonatomic, retain) NSString* mserverInfo;
@property (nonatomic, retain) NSString* muserid;
@property (nonatomic, retain) NSString* musername;
@property (nonatomic, retain) NSString* mfullname;
@property (nonatomic, retain) NSString* mcellphone;
@property (nonatomic, retain) NSString* mprovince;
@property (nonatomic, retain) NSString* mcity;
@property (nonatomic, retain) NSString* mcounty;
@property (nonatomic, retain) NSString* maddress;
@property (nonatomic, retain) NSString* mamount;
@property (nonatomic, retain) NSString* mordertime;
@property (nonatomic, retain) NSString* mitemdata;

-(void)postOkorder;
-(void)onPostOkorderResponse:(GDataXMLDocument*)xmlDoc;

-(OkorderStatistic*)existsInDBWithOrderId:(NSString*)orderId;
-(void)saveSelf;

@end
