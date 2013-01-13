//
//  BSPreviewScrollView.m
//
//  Created by Björn Sållarp on 7/14/10.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "BSPreviewScrollView.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)

@implementation BSPreviewScrollView
@synthesize scrollView, pageSize, delegate, alignment;
@synthesize scrollEnabled = _scrollEnabled;


- (void)awakeFromNib
{
	firstLayout = YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		firstLayout = YES;
	}
	
	return self;
}

- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size 
{    
	if (self = [self initWithFrame:frame]) 
	{
		self.pageSize = size;
    }
    return self;
}

-(void)loadPage:(int)page
{
	// Sanity checks
    if (page < 0) return;
    if (page >= [scrollViewPages count]) return;
	
	// Check if the page is already loaded
	UIView *view = [scrollViewPages objectAtIndex:page];
	
	// if the view is null we request the view from our delegate
	if ((NSNull *)view == [NSNull null]) 
	{
		view = [delegate viewForItemAtIndex:self index:page];
		[scrollViewPages replaceObjectAtIndex:page withObject:view];
	}else{
        NSLog( @"[SYS]scrollViewPage at %d reused.", page );
    }
	
	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) 
	{
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
		viewFrame.origin.y = 0;
		
		view.frame = viewFrame;
		
		[self.scrollView addSubview:view];
	}
}

- (void)setScrollEnabled:(BOOL)yesOrno{
    _scrollEnabled = yesOrno;
    [scrollView setScrollEnabled:_scrollEnabled];
}


- (void)layoutSubviews
{
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)
	{
			  
		// Position and size the scrollview. It will be centered in the view.
        
        CGRect scrollViewRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
        
        if ( alignment == NO ) {
            scrollViewRect.origin.x = ((self.frame.size.width - pageSize.width) / 2);
            scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2);
        }else{
            scrollViewRect.origin.x = 0.f;
            scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2);
        }
		 
		scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		scrollView.clipsToBounds = NO; // Important, this creates the "preview"
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollEnabled = _scrollEnabled;
		scrollView.delegate = self;
		
		[self addSubview:scrollView];
		
		
		int pageCount = [delegate itemCount:self];
		scrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
		
		// Fill our pages collection with empty placeholders
		for(int i = 0; i < pageCount; i++)
		{
			[scrollViewPages addObject:[NSNull null]];
		}
		
		// Calculate the size of all combined views that we are scrolling through
        if ( alignment == NO ) {
            self.scrollView.contentSize = CGSizeMake([delegate itemCount:self] * self.scrollView.frame.size.width, scrollView.frame.size.height);
        }else{
            self.scrollView.contentSize = CGSizeMake(( [delegate itemCount:self] - 2 ) * self.scrollView.frame.size.width, scrollView.frame.size.height);
        }
		
		// Load the first two pages
		for ( int i = 0; i < [scrollViewPages count]; i++ ) {
            [self loadPage:i];
        }
		
		firstLayout = NO;
	}
}

- (void)reloadData{
    
    for ( UIView* aView in scrollViewPages ) {
        [aView removeFromSuperview];
    }
    
    [scrollViewPages removeAllObjects];
    
    int pageCount = [delegate itemCount:self];
    
    for(int i = 0; i < pageCount; i++)
    {
        [scrollViewPages addObject:[NSNull null]];
    }
    
    for ( int i = 0; i < [scrollViewPages count]; i++ ) {
        [self loadPage:i];
    }
}

- (void)next{
    
    // Position the view in our scrollview
    float viewWidth = scrollView.frame.size.width;
    int page = (int)[scrollView contentOffset].x / viewWidth;
    if ( page < ( [scrollViewPages count] - 2 ) ) {
        [scrollView setContentOffset:CGPointMake(( page + 1 ) * viewWidth, 0) animated:YES];
    }
}

- (void)prev{
    float viewWidth = scrollView.frame.size.width;
    int page = (int)[scrollView contentOffset].x / viewWidth;
    if ( page > 0 ) {
        [scrollView setContentOffset:CGPointMake( ( page - 1 ) * viewWidth, 0) animated:YES];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) {
        
        CGPoint newPt = [self convertPoint:point toView:self.scrollView];
        
        for ( UIView* aView in [scrollView subviews] ) {
            CGPoint viewPt = [self.scrollView convertPoint:newPt toView:aView];
            if ( [aView pointInside:viewPt withEvent:event] ) {
                return [aView hitTest:viewPt withEvent:event];
            }
        }
        
		return self.scrollView;
	}
	
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

-(int)currentPage
{
	// Calculate which page is visible 
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	return page;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)sv
{
	int page = [self currentPage];
	
	[delegate currentIndexUpdate:self index:page];
	// Load the visible and neighbouring pages 
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
}

#pragma mark -
#pragma mark Memory management

// didReceiveMemoryWarning is not called automatically for views, 
// make sure you call it from your view controller
- (void)didReceiveMemoryWarning 
{
	// Calculate the current page in scroll view
    int currentPage = [self currentPage];
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [scrollViewPages count]; i++) 
	{
		UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
	
}

- (void)dealloc 
{
	[scrollViewPages release];
	[scrollView release];
    [super dealloc];
}


@end
