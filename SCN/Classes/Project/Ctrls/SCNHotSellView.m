//
//  SCNHotSellView.m
//  SCN
//
//  Created by yuanli 11-11-1.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNHotSellView.h"

#import "Go2PageUtility.h"
#import "DataWorld.h"
#import "SCNHomeData.h"
#import "HJManagedImageV.h"
#import "BaseViewController.h"

@implementation SCNHotSellView



- (id)initWithFrame:(CGRect)frame parentVC:(UIViewController*)parentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.m_parentVC = parentVC;
        //标题背景
        UIView *productInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 24)];
        productInfoView.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
        [self addSubview:productInfoView];
        
        //商品信息
        UILabel *descLable = [[UILabel alloc]initWithFrame:CGRectMake(98, 3, 221, 21)];
        descLable.textAlignment = UITextAlignmentLeft;
        descLable.backgroundColor = [UIColor clearColor];
        descLable.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0];
        descLable.font = [UIFont systemFontOfSize:13];
        self.m_descLable = descLable;
        [self addSubview:self.m_descLable];
        self.m_descLable.text = @"商品详情";
        
        //scrollview
        HLayoutView *LayView = [[HLayoutView alloc]initWithFrame:CGRectMake(7, 30, 306, 54)];
        LayView.delegate = self;
        LayView.backgroundColor = [UIColor clearColor];
        self.m_hotSellScroll = LayView;
        [self addSubview:LayView];
        

        
        UIImageView *offImageV = [[UIImageView alloc]initWithFrame:CGRectMake(6, 5, 85, 25)];
        [offImageV setImage:[DataWorld getImageWithFile:@"home_off.png"]];
        [self addSubview:offImageV];
    
        UILabel *offLable = [[UILabel alloc]initWithFrame:CGRectMake(6, 5, 84, 21)];
        offLable.textAlignment = UITextAlignmentCenter;
        offLable.backgroundColor = [UIColor clearColor];
        offLable.textColor = [UIColor whiteColor];
        offLable.font = [UIFont systemFontOfSize:14];
        
        self.m_offLable = offLable;
        [self addSubview:offLable];
        [self refreshData];
        
    }
    return self;
}

-(void)refreshData
{
    [self layoutHotSaleViewwithSpacing:9];
    [self updateHotLableProductInfo:0];
}

#pragma mark -
#pragma mark layoutHotSaleView
-(void)layoutHotSaleViewwithSpacing:(int)spacing 
{
    [self.m_hotSellScroll setToNavi];
    self.m_hotSellScroll.pagingEnabled = NO;
    self.m_hotSellScroll.clipsToBounds = NO;
    
    self.m_hotSellScroll.spacing = spacing;
    
    GY_Collection_Home* home_data = [DataWorld shareData].m_home;
    
    if ( home_data != nil ) {
        
        for (int i=0; i<[home_data.arr_hot_goods count]; i++)
        {
            NSMutableDictionary* dict = home_data.arr_hot_goods[i];
            
            
            HJManagedImageV *hjHSV = [[HJManagedImageV alloc]initWithFrame:
                                      CGRectMake(0, 0, (self.m_hotSellScroll.frame.size.width-4*spacing)/5, 54)];
            [hjHSV setImage:[DataWorld getImageWithFile:@"com_loading54x54.png"]];
            hjHSV.userInteractionEnabled = YES;
			
            if ( [hjHSV.layer respondsToSelector:@selector(setShadowOffset:)] ) {//设置阴影效果
                [hjHSV.layer setShadowOffset:CGSizeMake(2, 2)];
                [hjHSV.layer setShadowRadius:2];
                [hjHSV.layer setShadowOpacity:0.8]; 
                [hjHSV.layer setShadowColor:[UIColor lightGrayColor].CGColor];
            }
			hjHSV.layer.borderWidth = 1;
			hjHSV.layer.borderColor = YK_IMAGEBORDER_COLOR.CGColor;
			
            CustomHomeVCButton *hotButton = [CustomHomeVCButton buttonWithType:UIButtonTypeCustom];
            hotButton.backgroundColor = [UIColor clearColor];
            hotButton.frame = CGRectMake(0, 0, (self.m_hotSellScroll.frame.size.width-4*spacing)/5, 54);
            [hotButton addTarget:self action:@selector(onActionButton:) forControlEvents:UIControlEventTouchUpInside];
            [hjHSV addSubview:hotButton];
            
            hotButton.m_off = [NSString stringWithFormat:@"%d元",(NSInteger)dict[@"good_price"]];
            hotButton.m_title = dict[@"good_name"];
            hotButton.m_productCode = dict[@"good_id"];
            hotButton.m_image = dict[@"good_logo"];
            hotButton.m_pstatus = 0;
            
                        
            [self.m_hotSellScroll addSubview:hjHSV];
            [HJImageUtility queueLoadImageFromUrl:hotButton.m_image imageView:hjHSV];
        }
        //为了最后一个视图能滑倒最左边
        for (int m = 0; m<4; m++) {
            UIImageView *tempImagv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (self.m_hotSellScroll.frame.size.width-4*spacing)/5, 54)];
            tempImagv.backgroundColor = [UIColor clearColor];
            [self.m_hotSellScroll addSubview:tempImagv];
        }
    }
	self.m_hotSellScroll.alwaysBounceHorizontal = YES;
}
-(void)onActionButton:(id)sender
{
    CustomHomeVCButton *button = (CustomHomeVCButton *)sender;
    [Go2PageUtility go2WhichViewController:(BaseViewController *)self.m_parentVC 
                                  withType:@"single" 
                           withProductCode:button.m_productCode 
                              withPStatues:button.m_pstatus 
                             withImagesUrl:button.m_image 
                                 withTitle:button.m_title 
                             withTypeValue:nil];
}
#pragma mark-
#pragma mark ScrollviewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
    [self fixScrollowView:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixScrollowView:scrollView];
}
-(void)fixScrollowView:(UIScrollView *)scrollView
{

		CGFloat x = scrollView.contentOffset.x;
		int  hotIndex =  x/(54 + 9);
		CGFloat isHalf = x - hotIndex*(54 + 9)-27;
		if (isHalf>0) {
            hotIndex++;
			[scrollView setContentOffset:CGPointMake((54 + 9)*hotIndex, 0) animated:YES];
		}else {
			[scrollView setContentOffset:CGPointMake((54 + 9)*hotIndex, 0) animated:YES];
		}
        [self updateHotLableProductInfo:hotIndex];
}
-(void)updateHotLableProductInfo:(int)index
{
    NSMutableArray* hot_goods = [DataWorld shareData].m_home.arr_hot_goods;
    if ( [ hot_goods count ]>0) {
        
        NSMutableDictionary *dict = (NSMutableDictionary *)hot_goods[index];
        self.m_offLable.text = [NSString stringWithFormat:@"%@ 元", dict[@"good_price"] ];
        self.m_descLable.text = dict[@"good_name"];
    }
}


@end



@implementation CustomHomeVCButton


@end