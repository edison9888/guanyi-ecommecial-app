//
//  SCNBrowserData.h
//  SCN
//
//  Created by yuanli on 11-10-26.
//  Copyright 2011 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNBrowserData : YK_BaseData{
    NSString *mproudctCode;
    NSString *mimageUrl;
    
    NSString *mname;
    NSString *msex;
    NSString *mbrand;
    NSString *mpstatus;
    NSString *mmarketPrice;
    NSString *msellPrice;
    NSString* mbn;
}
@property (nonatomic, strong) NSString *mproudctCode;
@property (nonatomic, strong) NSString *mimageUrl;

@property (nonatomic, strong) NSString *mname;
@property (nonatomic, strong) NSString *msex;
@property (nonatomic, strong) NSString *mbrand;
@property (nonatomic, strong) NSString *mpstatus;
@property (nonatomic, strong) NSString *mmarketPrice;
@property (nonatomic, strong) NSString *msellPrice;
@property (nonatomic, strong) NSString* mbn;


@end

@interface SCNNowProductData : NSObject
{
	NSString* m_productName;
	NSString* m_productCode;
}

@property (nonatomic, strong) NSString *m_productName;
@property (nonatomic, strong) NSString *m_productCode;

@end

@interface SCNNowClassifiedData : NSObject
{
	NSString* m_classifiedName;
	NSString* m_parentClassifiedName;
}
@property (nonatomic, strong) NSString *m_classifiedName;
@property (nonatomic, strong) NSString *m_parentClassifiedName;

@end


