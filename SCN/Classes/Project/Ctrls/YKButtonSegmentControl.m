//
//  YKButtonSegmentControl.m
//  testSegment
//
//  Created by yek on 11-1-13.
//  Copyright 2011 yek. All rights reserved.
//

#import "YKButtonSegmentControl.h"

@interface YKButtonSegmentControl() 
-(void)onButtonClick:(id) sender;

@end


@implementation YKButtonSegmentControl

/*
-(id) awakeAfterUsingCoder:(NSCoder *)aDecoder{
	NSLog(@"-(id) awakeAfterUsingCoder:(NSCoder *)aDecoder enter...");
	YKButtonSegmentControl* ret=(YKButtonSegmentControl*)[super awakeAfterUsingCoder:aDecoder];
	for(int i=0; i<[ret.subviews count]; ++i){
		UIView* subView=[ret.subviews objectAtIndex:i];
		if([subView isKindOfClass:[UIButton class]]){
			UIButton* button=(UIButton*)subView;
			[button addTarget:ret action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
			[buttonArray addObject:button];
			if([button isSelected] && selectedIndex<0){
				selectedIndex=i;
			}
		}
	}
	return ret;
}
 */


-(void) awakeFromNib{
    
	selectedIndex=-1;
	buttonArray=[[NSMutableArray alloc] init];
	
	for(int i=0; i<[self.subviews count]; ++i){
		UIView* subView=[self.subviews objectAtIndex:i];
		if([subView isKindOfClass:[UIButton class]]){
			UIButton* button=(UIButton*)subView;
			[button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
			[buttonArray addObject:button];
			if([button isSelected] && selectedIndex<0){
				selectedIndex=i;
			}
		}
	}
}
-(void) dealloc{
	NSLog(@"%@::dealloc enter...",self);
}

-(void)onButtonClick:(id) sender{
	//UIButton* button=(UIButton*) sender;
	for(int i=0; i<[buttonArray count]; ++i){
		id obj=[buttonArray objectAtIndex:i];
		if([obj isEqual:sender]){
			//由于有时同一按钮需要处理不同的状态所以不能过滤 if(i!=selectedIndex){
				[self selectIndex:i];
				[self sendActionsForControlEvents:UIControlEventValueChanged];	
				break;
			//}
		}
	}
}

-(int) selectedIndex{
	return selectedIndex;
}

-(UIButton*) selectedButton{
	if(selectedIndex>[buttonArray count]-1){
		return nil;
	}
	return [buttonArray objectAtIndex:selectedIndex];
}

-(void) selectIndex:(int)index{
	selectedIndex=index;
	for(int i=0;i<[buttonArray count];++i){
		UIButton* button=(UIButton*)[buttonArray objectAtIndex:i];
		if(i==selectedIndex){
			[button setSelected:YES];
		}else{
			[button setSelected:NO];
		}
	}
}

-(UIButton *) buttonAtIndex:(int)index{
	return [buttonArray objectAtIndex:index];
}

@end
