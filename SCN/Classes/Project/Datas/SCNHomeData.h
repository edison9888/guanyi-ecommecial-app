//
//  SCNHomeData.h
//  SCN
//
//  Created by yuanli on 11-9-29.
//  Copyright 2011 Yek.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"


@interface SCNHomeData : NSObject{


}

@end

/*...................................................*/
@interface coverflowHomeData : YK_BaseData{
    
    NSString *mtype;
    NSString *mimage;
    NSString *mid;

}
@property (nonatomic, retain) NSString *mid;
@property (nonatomic, retain) NSString *mtype;
@property (nonatomic, retain) NSString *mimage;
@end

/*...................................................*/
@interface activityHomeData : YK_BaseData{
    
    NSString *mtitle;
    NSString *moff;
    NSString *mproductCode;
    NSString *mimage;
}
@property (nonatomic, retain) NSString *mtitle;
@property (nonatomic, retain) NSString *moff;
@property (nonatomic, retain) NSString *mproductCode;
@property (nonatomic, retain) NSString *mimage;
@end
/*...................................................*/
@interface topicHomeData : YK_BaseData{
    NSString *mtitle;
    NSString *mproductCode;
    NSString *mtype;
    NSString *micon;
    
}
@property (nonatomic, retain) NSString *mtitle;
@property (nonatomic, retain) NSString *mproductCode;
@property (nonatomic, retain) NSString *mtype;
@property (nonatomic, retain) NSString *micon;
@end