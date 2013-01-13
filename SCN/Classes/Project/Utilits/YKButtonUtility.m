//
//  YKButtonUtility.m
//  YK_B2C
//
//  Created by fan wt on 11-4-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YKButtonUtility.h"
#import "YKImageUtility.h"
#import "DataWorld.h"
@implementation YKButtonUtility

+(UIButton *)initSimpleButton:(CGRect)rect
						title:(NSString *)title 
				  normalImage:(NSString *)imageName 
				  highlighted:(NSString *)imageName_highlighted{
//	if (rect.size.width > 80.0f) {
//		rect = CGRectMake(rect.origin.x, rect.origin.y, 80.0f, rect.size.height);
//	}
	UIButton *l_button = [[UIButton alloc] init];
	UIImage* imageUnselected = [UIImage imageFileNamed:imageName];
	imageUnselected = [imageUnselected stretchableImageWithLeftCapWidth:23 topCapHeight:0];
	UIImage* imageSelected = [UIImage imageFileNamed:imageName_highlighted];
	imageSelected = [imageSelected stretchableImageWithLeftCapWidth:23 topCapHeight:0];
	[l_button setBackgroundImage:imageUnselected forState:UIControlStateNormal];
	[l_button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	l_button.titleLabel.textAlignment = UITextAlignmentCenter;
	l_button.frame = CGRectMake(rect.origin.x, 
								rect.origin.y, 
								rect.size.width, 
								imageUnselected.size.height);
	[l_button setTitle:title forState:UIControlStateNormal];
	return l_button;
}

+(UIButton *)initSimpleButtonWithCapWidth:(CGRect)rect
						title:(NSString *)title 
				  normalImage:(NSString *)imageName 
				  highlighted:(NSString *)imageName_highlighted 
					 capWidth:(int)capWidth
{
	//	if (rect.size.width > 80.0f) {
	//		rect = CGRectMake(rect.origin.x, rect.origin.y, 80.0f, rect.size.height);
	//	}
	UIButton *l_button = [[UIButton alloc] init];
	UIImage* imageUnselected = [UIImage imageFileNamed:imageName];
	imageUnselected = [imageUnselected stretchableImageWithLeftCapWidth:capWidth topCapHeight:imageUnselected.size.height];
	UIImage* imageSelected = [UIImage imageFileNamed:imageName_highlighted];
	imageSelected = [imageSelected stretchableImageWithLeftCapWidth:capWidth topCapHeight:imageSelected.size.height];
	[l_button setBackgroundImage:imageUnselected forState:UIControlStateNormal];
	[l_button setBackgroundImage:imageSelected forState:UIControlStateHighlighted];
	[l_button setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
	[l_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	l_button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	l_button.titleLabel.textAlignment = UITextAlignmentCenter;
	l_button.frame = CGRectMake(rect.origin.x, 
								rect.origin.y, 
								rect.size.width, 
								imageUnselected.size.height);
	[l_button setTitle:title forState:UIControlStateNormal];
	return l_button;
}

+(UIView *)initBgCornerViewWithHeight:(CGFloat)height cornerRadius:(CGFloat)cornerRadius{
    //设置View大小
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, height)];
    //设置View的背景颜色
    [view setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    //设置圆角半径
    [view.layer setCornerRadius:cornerRadius];
    //设置边框宽度
    [view.layer setBorderWidth:1];
    //设置边框颜色
    [view.layer setBorderColor:[UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1].CGColor];
    return view;
}
+(void)setCommonCellBgCornerView:(UITableViewCell*)cell{
    //设置View大小
    UIView *view=[[UIView alloc] initWithFrame:cell.frame];
    //设置View的背景颜色
    [view setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    //设置圆角半径
    [view.layer setCornerRadius:5];
    //设置边框宽度
    [view.layer setBorderWidth:1];
    //设置边框颜色
    [view.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
    cell.backgroundView=view;
}
+(void)setCommonCellBg:(UITableViewCell *)cell
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"com_normalCellBackground.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"com_selectCellBackground.png"]];
}
@end
