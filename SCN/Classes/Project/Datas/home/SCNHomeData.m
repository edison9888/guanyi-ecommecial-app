//
//  SCNHomeData.m
//  SCN
//
//  Created by yuanli on 11-9-29.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNHomeData.h"

@implementation SCNHomeData
@synthesize m_activityDatasArr,m_productlistDatasArr,m_topicDatasArr,m_topic_itemDatasArr;
@synthesize m_productlistTitle;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end

/*...........................................................*/
@implementation activityHomeData

@synthesize mtype,mtypename,mproductCode,mimage,mpstatus;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end

/*...........................................................*/
@implementation productlistHomeData

@synthesize mtitle,moff,mproductCode,mimage,mpstatus;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end





/*...........................................................*/
@implementation topicHomeData

@synthesize mtitle,mproductCode,mtype,mimage,mpstatus,mmodel;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end