//
//  BadgeView.h
//  USHI
//
//  Created by Mac on 10-1-12.
//  Copyright 2010 yek.com All rights reserved.
//

#import <UIKit/UIKit.h>  
//#import "Definer.h"  


@interface BadgeView : UIView 
{
	NSMutableArray*	nums;
	UIImage*		bg_img;
	UIImageView*	iv_bg;
	int badgeValue;
}

@property int badgeValue;

-(void)setBadge:(int)_badgeValue;

@end
