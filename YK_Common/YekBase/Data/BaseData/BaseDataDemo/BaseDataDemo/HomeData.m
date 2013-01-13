//
//  HomeData.m
//  BaseDataDemo
//
//  Created by wtfan on 11-10-20.
//  Copyright (c) 2011年 Yek. All rights reserved.
//

#import "HomeData.h"

@implementation HomeData

@synthesize m_mutArray_topic;
@synthesize MCDATAValue;

DECLARE_PROPERTIES(
                   DECLARE_PROPERTY(@"CDATAValue", @"@\"NSString\"")
				   )

/**
 <home result="success">
 <topiclist type="A">
 <topic type="buy" topicid="aaaa" searchKey="001" title="限时限量 5折秒杀" sub="手机用户专享活动 每日更新中" image="iphone/i4/miaosha/shouye_m1.jpg"/>
 <topic type="buy" topicid="bbbb" searchKey="002" title="限时限量 5折秒杀" sub="手机用户专享活动 每日更新中" image="iphone/i4/miaosha/shouye_m2.jpg"/>
 <description><![CDATA[带格式的CDATA]]></description>
 </topiclist>
 </home>
 */
DECLARE_STRUCTS(@"                                      \
                {                                       \
                \"Class\": \"HomeData\"                 \
                \"NodePath\": \"//home/topiclist\"      \
                \"CDATAName\": \"description\"       \
                \"CDATAValue\": \"MCDATAValue\"           \
                \"m_mutArray_topic\": \"Topic\"             \
                }"
                )

-(id)init{
    self = [super init];
    if (self) {
        m_mutArray_topic = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}
                
-(void)dealloc{
    self.m_mutArray_topic = nil;
    self.MCDATAValue = nil;
    
    [super dealloc];
}

-(void)addm_mutArray_topic:(Topic*)topic{
    [m_mutArray_topic addObject:topic];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"[SYS - HomeData] MCDATAValue: %@", MCDATAValue];
}

@end




@implementation Topic

@synthesize mtype;
@synthesize mtopicid;
@synthesize msearchKey;
@synthesize mtitle;
@synthesize msub;
@synthesize mimage;
@synthesize mdescription;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mtype", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mtopicid", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"msearchKey", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mtitle", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"msub", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mimage", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mdescription", @"@\"NSString\"")
				   )

DECLARE_STRUCTS(@"                                      \
                {                                       \
                \"Class\": \"Topic\"                      \
                \"NodePath\": \"//topiclist/topic\"       \
                \"CDATAName\": \"description\"       \
                \"CDATAValue\": \"mdescription\"                  \
                }"
                )

-(void)dealloc{
    self.mtype = nil;
    self.mtopicid = nil;
    self.msearchKey = nil;
    self.mtitle = nil;
    self.msub = nil;
    self.mimage = nil;
    self.mdescription = nil;
    
    [super dealloc];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"[SYS - Topic] mtype: %@, \
            mtopicid: %@, \
            msearchKey: %@, \
            mtitle: %@, \
            msub: %@, \
            mimage: %@, \
            mdescription: %@", mtype, mtopicid, msearchKey, mtitle, msub, mimage, mdescription];
}

@end
