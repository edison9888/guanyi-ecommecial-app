//
//  YKButtonSegmentControl.h
//  testSegment
//
//  Created by yek on 11-1-13.
//  Copyright 2011 yek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 按钮segmentview
 使用指南
 1.使用ib 新建一个view1 ，view1 的 class 为：YKButtonSegmentControl
 2.在view1中添加几个按钮及其他的背景等。
 3.调用时[view1 addTarget:** action:** event:UIControlEventValueChange];
 
 */
@interface YKButtonSegmentControl : UIControl {
	NSMutableArray* buttonArray;
	int selectedIndex;
}

-(void) selectIndex:(int) index;
-(int) selectedIndex;
-(UIButton*) buttonAtIndex:(int) index;
-(UIButton*) selectedButton;

@end
