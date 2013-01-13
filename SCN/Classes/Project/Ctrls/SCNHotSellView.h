//
//  SCNHotSellView.h
//  SCN
//
//  Created by yuanli 11-11-1.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutManagers.h"
#import "GY_Collections.h"

@interface SCNHotSellView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) HLayoutView     *m_hotSellScroll;
@property (nonatomic, strong) UILabel         *m_offLable;
@property (nonatomic, strong) UILabel         *m_descLable;
@property (nonatomic, unsafe_unretained) UIViewController* m_parentVC;

- (id)initWithFrame:(CGRect)frame parentVC:(UIViewController*)parentVC;
-(void)refreshData;
-(void)layoutHotSaleViewwithSpacing:(int)spacing;
-(void)fixScrollowView:(UIScrollView *)scrollView;
-(void)updateHotLableProductInfo:(int)index;
@end


@interface CustomHomeVCButton :UIButton

@property (nonatomic, strong) NSString *m_type;
@property (nonatomic, strong) NSString *m_typename;
@property (nonatomic, strong) NSString *m_productCode;
@property (nonatomic, strong) NSString *m_image;
@property (nonatomic, strong) NSString *m_pstatus;

@property (nonatomic, strong) NSString *m_title;
@property (nonatomic, strong) NSString *m_off;

@end