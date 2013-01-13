//
//  GY_Model_Category.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GY_BaseModel.h"

@interface GY_Model_Category : GY_BaseModel


@property (nonatomic, strong) NSString  *mimage;
@property (nonatomic, strong) NSString  *mname;
@property (nonatomic, strong) NSString  *mfatherId;
@property (nonatomic, strong) NSString  *mcategoryId;
@property (nonatomic, strong) NSString  *mchildNum;



@end
