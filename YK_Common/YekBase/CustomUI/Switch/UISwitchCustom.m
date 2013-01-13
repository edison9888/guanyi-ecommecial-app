//
//  UISwitchCustom.m
//  SCN
//
//  Created by zwh on 11-10-13.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "UISwitchCustom.h"

#define KDefaultSlideWidth 30

@implementation UISwitchCustom
@synthesize delegate=_delegate;
@synthesize on=_on;


- (void)setupUserInterface
{
	_on = YES;
	_slideWidth = KDefaultSlideWidth;
	
	CGRect viewrect = self.bounds;
	
	_offImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewrect.size.width - _slideWidth, 0, viewrect.size.width, viewrect.size.height)];
	[self addSubview:_offImage];
	_offImage.userInteractionEnabled = NO;
	
	_onImage = [[UIImageView alloc] initWithFrame:viewrect];
	[self addSubview:_onImage];
	_onImage.userInteractionEnabled = NO;
	
}

- (id)initWithFrame:(CGRect)frame
{
	if (self == [super initWithFrame:frame])
	{
		self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.autoresizesSubviews=NO;
        self.autoresizingMask=0;
        self.opaque=YES;
		
		[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self setupUserInterface];
	}
	return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
	{
		self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.autoresizesSubviews=NO;
        self.autoresizingMask=0;
        self.opaque=YES;
		
		[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self setupUserInterface];
	}
    return self;
}

- (void)layoutSubviews
{
	//[UIView beginAnimations:nil context:nil];
	CGRect viewrect = self.bounds;
	CGRect onrect = self.bounds;
	CGRect offrect = CGRectMake(viewrect.size.width - _slideWidth, 0, viewrect.size.width, viewrect.size.height);
	CGRect sliderect = CGRectMake(viewrect.size.width - _slideWidth, 0, _slideWidth, viewrect.size.height);
	if (!_on)
	{
		CGFloat runlen = viewrect.size.width - _slideWidth;
		onrect.origin.x -= runlen;
		offrect.origin.x -= runlen;
		sliderect.origin.x -= runlen;
	}
	_offImage.frame = offrect;
	_onImage.frame = onrect;
}

-(void)setImageFinishedState
{
	_onImage.hidden = !_on;
	_offImage.hidden = _on;
	isAnimating = NO;
}

-(void)layoutAnimated:(BOOL)animated sel:(SEL)selector
{
	if (animated)
	{
		isAnimating = YES;
		_onImage.hidden = NO;
		_offImage.hidden = NO;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
	}
	
	[self layoutSubviews];
	
	if (animated)
	{
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:selector];
		[UIView commitAnimations];
	}
	else
	{
		[self setImageFinishedState];
	}
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
	_on = on;
	[self layoutAnimated:animated sel:@selector(animateHasFinished:)];
}


- (void)animateHasFinished:(NSString *)animationID
{
	[self setImageFinishedState];
}

- (void)buttonPressed:(id)target
{
	if (isAnimating)
	{
		return ;
	}
	_on = !_on;
	[self layoutAnimated:YES sel:@selector(animateHasFinished:finished:context:)];
}

- (void)animateHasFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	[self setImageFinishedState];
	if([_delegate respondsToSelector:@selector(valueChangedInView:)])
	{
		[_delegate valueChangedInView:self];
	}
	NSLog(@"animateHasFinished:%d",_on);
}

- (BOOL)isOn
{
    return _on;
}

- (void)setOnImage:(UIImage*)image
{
	[_onImage setImage:image];
	[self setNeedsLayout];
}

- (void)setOffImage:(UIImage*)image
{
	[_offImage setImage:image];
	[self setNeedsLayout];
}

- (void)setSlideWidth:(CGFloat)width
{
	_slideWidth = width;
	[self setNeedsLayout];
}


@end