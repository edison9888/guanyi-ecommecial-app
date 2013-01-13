//
//  BSPreviewScrollView.h
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class BSPreviewScrollView;

@protocol BSPreviewScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index;
-(int)itemCount:(BSPreviewScrollView*)scrollView;
-(void)currentIndexUpdate:(BSPreviewScrollView*)scrollView index:(int)index;
@end


@interface BSPreviewScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;	
	id<BSPreviewScrollViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
    BOOL alignment;
    @private
    BOOL _scrollEnabled;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<BSPreviewScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL alignment;
@property (nonatomic, assign, setter = setScrollEnabled:) BOOL scrollEnabled;
- (void)next;
- (void)prev;
- (void)didReceiveMemoryWarning;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;
- (void)reloadData;
@end
