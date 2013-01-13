//
//  YK_ButtonUtility.h
//  Moonbasa
//
//  Created by user on 11-7-20.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>

//UIButton宏定义
#define BUTTON_TAG 110

@interface YK_ButtonUtility : NSObject {

}

/**
	根据ImageName创建自定义按钮
	@param imageName 图片名称
    @param highlightedImageName 高亮图片名称
	@param rect 大小
	@param target 回调对象
	@param sel 回调方法
	@returns 自定义按钮
 */
+(UIButton*)customButtonWithImageName:(NSString*)imageName
			 withHighlightedImageName:(NSString*)highlightedImageName
							 withRect:(CGRect)rect target:(id)target action:(SEL)sel;

/**
     根据ImageName创建自定义按钮
     @param imageName 图片名称
     @param highlightedImageName 高亮图片名称
     @param rect 大小
     @param target 回调对象
     @param sel 回调方法
     @returns 自定义按钮
 */
+(UIView*)customButtonViewWithImageName:(NSString*)imageName
			 withHighlightedImageName:(NSString*)highlightedImageName
							 withRect:(CGRect)rect target:(id)target action:(SEL)sel;

/**
	根据ImageName和title创建自定义按钮
	@param imageName 图片名称
	@param highlightedImageName 高亮图片名称
	@param title 按钮标题
	@param font 字体
	@param target 回调对象
	@param sel 回调方法
	@returns 自定义按钮
 */
+(UIButton*)customButtonWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName	title:(NSString*)title font:(UIFont *)font target:(id)target action:(SEL)sel;

/**
     根据ImageName和title创建自定义按钮
     @param imageName 图片名称
     @param highlightedImageName 高亮图片名称
     @param title 按钮标题
     @param font 字体
     @param target 回调对象
     @param sel 回调方法
     @returns 自定义按钮
 */
+(UIView*)customButtonViewWithImageName:(NSString*)imageName highlightedImageName:(NSString*)highlightedImageName	title:(NSString*)title font:(UIFont *)font target:(id)target action:(SEL)sel;

/**
 根据ImageName和title创建自定义按钮
 @param backImageName 背景图片名称
 @param frontImageName 前置图片名称
 @param highlightedImageName 高亮图片名称
 @param frontHighlightedImageName 前置高亮图片名称
 @param target 回调对象
 @param sel 回调方法
 @returns 自定义按钮
 */
+(UIView*)customButtonViewWithBackImageName:(NSString*)backImageName
                             frontImageName:(NSString*)frontImageName
                   highlightedBackImageName:(NSString*)highlightedImageName
                  frontHighlightedImageName:(NSString*)frontHighlightedImageName
                                     target:(id)target action:(SEL)sel;
@end
