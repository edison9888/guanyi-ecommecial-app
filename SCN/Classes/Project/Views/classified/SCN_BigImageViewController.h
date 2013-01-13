//
//  SCN_BigImageViewController.h
//  SCN
//
//  Created by yuanli on 11-10-12.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//#import "EasyTableView.h"
#import "ATPagingView.h"
#import "GrayPageControl.h"

@interface SCN_BigImageViewController : BaseViewController<UIScrollViewDelegate,ATPagingViewDelegate>{
    ATPagingView            *m_atPagingView;
    GrayPageControl         *m_GpageControl;
    
    NSMutableArray          *m_imageArr;
    int                     m_lastPags;
	int						m_firstIndex;
}
@property (nonatomic, assign) int                     m_lastPags;
@property (nonatomic, strong) NSMutableArray          *m_imageArr;
@property (nonatomic, strong) ATPagingView           *m_atPagingView;
@property (nonatomic, strong) GrayPageControl         *m_GpageControl;

-(id)initWithNibName:(NSString *)nibNameOrNil 
              bundle:(NSBundle *)nibBundleOrNil 
     withimageUrlArr:(NSMutableArray *)imageUrlArr
		   withIndex:(int)index;

-(void)onAction_goBack:(id)sender;

//行为统计
-(NSString*)pageJumpParam;

@end
