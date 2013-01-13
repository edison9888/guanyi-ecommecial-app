//
//  SyTextView.h
//  MBaoBao
//
//  Created by KangQiang on 10-11-23.
//  Copyright 2010 Seeyon ShangHai. All rights reserved.
//
//	带有占位符的文本编辑视图

#import <UIKit/UIKit.h>


@interface SyTextView : UITextView  {
    NSString		*placeholder;			// 占位符
    UIColor			*placeholderColor;		// 占位符颜色
	UILabel			*label;					// 占位符标签
}

@property (nonatomic, strong) NSString		*placeholder;
@property (nonatomic, strong) UIColor		*placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
