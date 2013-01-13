//
//  SCNHomeData.h
//  SCN
//
//  Created by yuanli on 11-9-29.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"


@interface SCNHomeData : NSObject{
    NSMutableArray  *m_activityDatasArr;        //顶部活动专区数据
    NSMutableArray  *m_productlistDatasArr;     //热销商品数据
    NSMutableArray  *m_topicDatasArr;           //栏目组区头数据
    NSMutableArray  *m_topic_itemDatasArr;      //栏目组每个区的数据
    
    NSString        *m_productlistTitle;        //热销商品区头标题

}
@property(nonatomic, strong) NSMutableArray  *m_activityDatasArr;
@property(nonatomic, strong) NSMutableArray  *m_productlistDatasArr;
@property(nonatomic, strong) NSMutableArray  *m_topicDatasArr;
@property(nonatomic, strong) NSMutableArray  *m_topic_itemDatasArr;

@property(nonatomic, strong) NSString        *m_productlistTitle;
@end


/*...................................................*/
@interface activityHomeData : YK_BaseData{
    
    NSString *mtype;
    NSString *mtypename;
    NSString *mproductCode;
    NSString *mimage;
    NSString *mpstatus;
}
@property (nonatomic, strong) NSString *mtype;
@property (nonatomic, strong) NSString *mtypename;
@property (nonatomic, strong) NSString *mproductCode;
@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *mpstatus;
@end

/*...................................................*/
@interface productlistHomeData : YK_BaseData{
    
    NSString *mtitle;
    NSString *moff;
    NSString *mproductCode;
    NSString *mimage;
    NSString *mpstatus;

}
@property (nonatomic, strong) NSString *mtitle;
@property (nonatomic, strong) NSString *moff;
@property (nonatomic, strong) NSString *mproductCode;
@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *mpstatus;
@end


/*...................................................*/
@interface topicHomeData : YK_BaseData{
    NSString *mtitle;
    NSString *mproductCode;
    NSString *mtype;
    NSString *mimage;
    NSString *mpstatus;
    NSString *mmodel;
    
}
@property (nonatomic, strong) NSString *mtitle;
@property (nonatomic, strong) NSString *mproductCode;
@property (nonatomic, strong) NSString *mtype;
@property (nonatomic, strong) NSString *mimage;
@property (nonatomic, strong) NSString *mpstatus;
@property (nonatomic, strong) NSString *mmodel;
@end