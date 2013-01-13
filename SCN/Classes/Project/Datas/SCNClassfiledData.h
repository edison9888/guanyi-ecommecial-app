//
//  SCNClassfiledData.h
//  SCN
//
//  Created by yuanli on 11-10-9.
//  Copyright 2011 Yek.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
@interface SCNClassfiledData : YK_BaseData{

    NSString *micon;
    NSString *mname;
    NSString *mfatherId;
    NSString *mcategoryId;
    NSString *mchildNum;
    NSString *mbrandId;
}
@property (nonatomic, retain) NSString  *micon;
@property (nonatomic, retain) NSString  *mname;
@property (nonatomic, retain) NSString  *mfatherId;
@property (nonatomic, retain) NSString  *mcategoryId;
@property (nonatomic, retain) NSString  *mchildNum;
@property (nonatomic, retain) NSString  *mbrandId;
@end
