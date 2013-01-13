//
//  SCNMyCollectionData.h
//  SCN
//
//  Created by chenjie on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNMyCollectionData : YK_BaseData {
    NSString* mnumber;
    NSString* mimage;
    NSString* mname;
    NSString* mmarketPrice;
    NSString* msellPrice;
    NSString* mproductCode;
    NSString* mtotalSells;
    NSString* mpstatus;
    
}
@property (nonatomic, strong) NSString* mnumber;
@property (nonatomic, strong) NSString* mimage;
@property (nonatomic, strong) NSString* mname;
@property (nonatomic, strong) NSString* mmarketPrice;
@property (nonatomic, strong) NSString* msellPrice;
@property (nonatomic, strong) NSString* mproductCode;
@property (nonatomic, strong) NSString* mtotalSells;
@property (nonatomic, strong) NSString* mpstatus;


@end

@interface SCNMyCollectionPageinfoData  : YK_BaseData {
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
