//
//  YKButtonUtility.h
//  YK_B2C
//
//  Created by fan wt on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YKButtonUtility : NSObject

+(UIButton *)initSimpleButton:(CGRect)rect
							 title:(NSString *)title 
					   normalImage:(NSString *)imageName 
					   highlighted:(NSString *)imageName_highlighted;


+(UIButton *)initSimpleButtonWithCapWidth:(CGRect)rect
						title:(NSString *)title 
				  normalImage:(NSString *)imageName 
				  highlighted:(NSString *)imageName_highlighted 
					 capWidth:(int)capWidth;
/*
    获得圆角的UIView，默认坐标(10,5)，宽度300
    height:高度
    cornerRadius:圆角半径
 */
+(UIView *)initBgCornerViewWithHeight:(CGFloat)height cornerRadius:(CGFloat)cornerRadius;
/*
    设置cell的圆角背景
 */
+(void)setCommonCellBgCornerView:(UITableViewCell*)cell;
+(void)setCommonCellBg:(UITableViewCell *)cell; 
@end
