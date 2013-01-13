//
//  SCNProductFilterButton.h
//  SCN
//
//  Created by xie xu on 11-11-3.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SCNSearchData.h"

@interface SCNProductFilterButton : UIButton{
    SCNProductFilterItemData *m_filterItemData;
}
@property(nonatomic,strong)SCNProductFilterItemData *m_filterItemData;
@end
