//
//  SCNConsultationData.h
//  SCN
//
//  Created by chenjie on 11-10-18.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//   我的咨询数据
#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
@interface SCNConsultationData : YK_BaseData {
    NSString* musername;
    NSString* mcreateTime;
    NSString* maskcontent;
    NSString* mreplycontent;
 

}
@property (nonatomic, strong) NSString* musername;
@property (nonatomic, strong) NSString* mcreateTime;
@property (nonatomic, strong) NSString* maskcontent;
@property (nonatomic, strong) NSString* mreplycontent;
@end
@interface SCNConsulationPageData : YK_BaseData {
    NSString* mpage;
    NSString* mpageSize;
    NSString* mtotalPage;
    NSString* mnumber;
    
}
@property (nonatomic, strong) NSString* mpage;
@property (nonatomic, strong) NSString* mpageSize;
@property (nonatomic, strong) NSString* mtotalPage;
@property (nonatomic, strong) NSString* mnumber;
@end

@interface SCNConsulationGroup : YK_BaseData {
    NSString* mcommentId;              //咨询列表id
    NSMutableDictionary* m_mutdictionary_askAndreply;
}

@property (nonatomic, strong) NSString* mcommentId;
@property (nonatomic, strong) NSMutableDictionary* m_mutdictionary_askAndreply;
@end
