//
//  SCNClassfiledData.h
//  SCN
//
//  Created by yuanli on 11-10-9.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
@interface SCNClassfiledData : NSObject{
    
}

@end



@interface Category_Data  : YK_BaseData {
    
    NSString *mimage;
    NSString *mname;
    NSString *mfatherId;
    NSString *mcategoryId;
    NSString *mchildNum;

}
@property (nonatomic, strong) NSString  *mimage;
@property (nonatomic, strong) NSString  *mname;
@property (nonatomic, strong) NSString  *mfatherId;
@property (nonatomic, strong) NSString  *mcategoryId;
@property (nonatomic, strong) NSString  *mchildNum;






@end