//
//  SCNMyCommentaryData.h
//  SCN
//
//  Created by chenjie on 11-10-21.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNMyCommentaryData : YK_BaseData 
@property (nonatomic, strong) NSMutableArray* m_mutarray_comment;
@property (nonatomic, strong) NSString* mproductCode;
@property (nonatomic, strong) NSString* morderId;
@property (nonatomic, strong) NSString* mname;
@property (nonatomic, strong) NSString* mimage;
@property (nonatomic, strong) NSString* mcanComment;
@property (nonatomic, strong) NSString* mdesc;
@property (nonatomic, strong) NSString* mpstatus;
@end

@interface SCNMyCommentaryPageData : YK_BaseData

@property (nonatomic, strong) NSString* mpage;
@property (nonatomic, strong) NSString* mpageSize;
@property (nonatomic, strong) NSString* mtotalPage;
@property (nonatomic, strong) NSString* mnumber;

@end

@interface SCNMyCommentListData : YK_BaseData 
@property (nonatomic, strong) NSString* mcommentId;
@property (nonatomic, strong) NSString* mcommentStar;
@property (nonatomic, strong) NSString* musername;
@property (nonatomic, strong) NSString* mstarImage;
@property (nonatomic, strong) NSString* mcreateTime;
@property (nonatomic, strong) NSString* m_comment_content;
@end
