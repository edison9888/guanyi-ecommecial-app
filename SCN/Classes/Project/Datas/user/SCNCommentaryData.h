//
//  SCNCommentaryData.h
//  SCN
//
//  Created by chenjie on 11-10-21.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNCommentaryData : YK_BaseData
@property (nonatomic, strong) NSString* mcanComment;
@property (nonatomic, strong) NSMutableArray* m_mutarray_commentary;
@end



@interface SCNCommentaryGroup : YK_BaseData {
    NSString* mcommentId;              //咨询列表id
    NSMutableDictionary* m_mutdictionary_askAndreply;
}

@property (nonatomic, strong) NSString* mcommentId;
@property (nonatomic, strong) NSMutableDictionary* m_mutdictionary_askAndreply;
@end


@interface SCNCommentaryPageData : YK_BaseData {
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





@interface SCNCommentaryMember : YK_BaseData {

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