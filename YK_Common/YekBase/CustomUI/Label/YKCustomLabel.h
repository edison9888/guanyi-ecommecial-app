//
//  YKCustomLabel.h
//  MoonbasaIpad
//
//  Created by zhi.zhu on 11-9-16.
//  Copyright 2011 Yek. All rights reserved.
//
//  扩展UILabel使UILabel能够设置垂直方向的排布方式

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
	VerticalAlignmentTop,//垂直居上
	VerticalAlignmentMiddle,//垂直居中
	VerticalAlignmentBottom,//垂直居下
} VerticalAlignment;

@interface YKCustomLabel : UILabel{
@private
	VerticalAlignment verticalAlignment_;
}
@property (nonatomic, assign) VerticalAlignment verticalAlignment;
//设置YKCustomLabel文字的垂直排布方式
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment;
@end
