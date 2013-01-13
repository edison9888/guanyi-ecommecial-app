//
//  YKBaseView.h
//  YK
//
//  Created by blackApple-1 on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define BASEVIEW_TIMESPEC_TIMEINTERVAL 0.5

#import <UIKit/UIKit.h>


@interface YK_BaseView : UIView {

}

-(void)pushView:(UIView*)view withAnimation:(BOOL)animation;
-(void)popViewWithAnimation:(BOOL)animation;
@end
