//
//  SCNCommonPickerView.m
//  SCN
//
//  Created by huangwei on 11-10-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCommonPickerView.h"

@interface SCNCommonPickerView(PrivateMethods)
-(void)createPickerView;
@end

@implementation SCNCommonPickerView
@synthesize m_pickerView;
@synthesize m_pickerBar;
@synthesize m_elementNum;
@synthesize m_rowIndex;
@synthesize m_componentIndex;
@synthesize m_newRowIndex;
@synthesize m_pickerArray;
@synthesize m_delegate;
@synthesize m_showView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		m_showView = [[UIView alloc] initWithFrame:frame];
		m_showView.backgroundColor = [UIColor lightGrayColor];
		
		[self addTarget:self action:@selector(clickfreeSpace:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_showView];
		[self createPickerView];
		[self appearView];
    }
    return self;
}

- (void)clickfreeSpace:(id)sender
{
	[self disappearView];
}

- (void)appearView
{
	CGRect rect = m_showView.frame;
	CGRect orirect = rect;
	orirect.origin.y = CGRectGetMaxY(self.frame);
	//self.alpha = 0.3;
	m_showView.frame = orirect;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidAppear)];
	self.alpha = 1.0;
	m_showView.frame = rect;
	[UIView commitAnimations];
}

- (void)AnimateDidAppear
{
}

- (void)disappearView
{
	CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidDisappear)];
	rect.origin.y = CGRectGetMaxY(self.frame);
	m_showView.frame = rect;
	self.alpha = 0.3;
	[UIView commitAnimations];
}

- (void)AnimateDidDisappear
{
	[self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


-(void)createPickerView{
	if (m_pickerBar != nil) {
		[m_pickerBar removeFromSuperview];
		self.m_pickerBar = nil;
	}

	if (m_pickerView != nil) {
		[m_pickerView removeFromSuperview];
		self.m_pickerView = nil;
		return;
	}else {
		
	}
	if (nil == m_pickerBar) {
		UIBarButtonItem *pickItemCancle = [[UIBarButtonItem alloc]initWithTitle:@"取消"
																		  style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(doPickCancle)];
		pickItemCancle.style = UIBarButtonItemStyleBordered;
		
		UIBarButtonItem *pickItemOK = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(doPickOK)];
		pickItemOK.style = UIBarButtonItemStyleBordered;
		
		UIBarButtonItem *pickSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemFlexibleSpace
																				   target:self
																				   action:@selector(doSpace)];
		
		self.m_pickerBar = [[UIToolbar alloc] init];
		m_pickerBar.barStyle = UIBarStyleBlackTranslucent;
		NSArray *pickArray = @[pickItemCancle,pickSpace,pickItemOK];
		[m_pickerBar setItems:pickArray animated:YES];
		m_pickerBar.frame = CGRectMake(0, 0, 320, 44);
        
		[m_showView addSubview:m_pickerBar]; 
		
	}
	if (nil == m_pickerView) {
		self.m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
		
        CGRect pickRect = CGRectMake(0, 43, 320, 240);
        m_pickerView.frame = pickRect;
		
		m_pickerView.showsSelectionIndicator = YES;
		m_pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		m_pickerView.delegate = self;
		m_pickerView.dataSource = self;
		
		//[m_pickerView selectRow:rowIndex inComponent:componentIndex animated:NO];
		
		[m_showView addSubview:m_pickerView];
	}
}

#pragma mark UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	NSInteger numOfItems = m_elementNum;
	if ([m_delegate respondsToSelector:@selector(numberOfCellsForPickerView:)]) {
		numOfItems = [m_delegate numberOfCellsForPickerView:self];
	}
	return numOfItems;
}

#pragma mark UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 44;
}

-(NSString*)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
	NSString* _title = nil;
	if ([m_delegate respondsToSelector:@selector(titleForPickerView:)]) {
		self.m_pickerArray = [m_delegate titleForPickerView:self];
	}
	if ([self.m_pickerArray count] > 0)
	{
		_title = [NSString stringWithFormat:@"%@",[self.m_pickerArray objectAtIndex:row]];
		
	}
	return _title;
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
	m_newRowIndex = row;
	self.m_componentIndex = component;
	
//	if ([m_delegate respondsToSelector:@selector(scnCommonPickerView:didSelectRow:inComponent:)]) {
//		[m_delegate scnCommonPickerView:self didSelectRow:m_newRowIndex inComponent:m_componentIndex];
//	}
}


-(void)doPickCancle{
	[self disappearView];
}

-(void)doPickOK{
	if ([m_delegate respondsToSelector:@selector(scnCommonPickerView:didSelectRow:inComponent:)]) {
		[m_delegate scnCommonPickerView:self
                           didSelectRow:[m_pickerView selectedRowInComponent:0]
                            inComponent:m_componentIndex];
        [self disappearView];
	}
}

@end
