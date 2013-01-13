//
//  SCNProductTagLabel.h
//  SCN
//
//  Created by xie xu on 11-10-20.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SCNProductTagLabel : UILabel
{
    BOOL isleft;//是否左对齐
}
@property (nonatomic, assign) BOOL isleft;
@end
