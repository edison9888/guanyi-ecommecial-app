//
//  HomeData.h
//  BaseDataDemo
//
//  Created by wtfan on 11-10-20.
//  Copyright (c) 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"


@class Topic;

/**
 <home result="success">
    <topiclist type="A">
        <topic type="buy" topicid="aaaa" searchKey="001" title="限时限量 5折秒杀" sub="手机用户专享活动 每日更新中" image="iphone/i4/miaosha/shouye_m1.jpg"/>
        <topic type="buy" topicid="bbbb" searchKey="002" title="限时限量 5折秒杀" sub="手机用户专享活动 每日更新中" image="iphone/i4/miaosha/shouye_m2.jpg">
            <![CDATA[哇哈哈哈]]>
        </topic>
        <description><![CDATA[带格式的CDATA]]></description>
    </topiclist>
 </home>
 */
@interface HomeData : YK_BaseData{
    NSMutableArray* m_mutArray_topic;
    NSString* MCDATAValue;
}
@property (nonatomic, retain) NSMutableArray* m_mutArray_topic;
@property (nonatomic, retain) NSString* MCDATAValue;

-(void)addm_mutArray_topic:(Topic*)topic;

@end


@interface Topic : YK_BaseData {
    NSString* mtype;
    NSString* mtopicid;
    NSString* msearchKey;
    NSString* mtitle;
    NSString* msub;
    NSString* mimage;
    NSString* mdescription;
}
@property (nonatomic, retain) NSString* mtype;
@property (nonatomic, retain) NSString* mtopicid;
@property (nonatomic, retain) NSString* msearchKey;
@property (nonatomic, retain) NSString* mtitle;
@property (nonatomic, retain) NSString* msub;
@property (nonatomic, retain) NSString* mimage;
@property (nonatomic, retain) NSString* mdescription;
@end
