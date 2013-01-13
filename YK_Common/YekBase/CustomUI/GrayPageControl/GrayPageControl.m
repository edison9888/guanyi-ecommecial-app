//
//  GrayPageControl.m
//  Moonbasa
//
//  Created by zwh on 11-7-22.
//  Copyright 2011 yek.com All rights reserved.
//
#import "GrayPageControl.h"

@implementation GrayPageControl


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
	{
		self.activeImage = nil;
		self.inactiveImage = nil;
	}
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
	{
		self.activeImage = nil;
		self.inactiveImage = nil;
    }
    return self;
}

-(void) updateDots
{
	if(!self.activeImage || !self.inactiveImage)
		return;
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) dot.image = self.activeImage;
        else dot.image = self.inactiveImage;
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
-(void)dealloc
{
    self.inactiveImage = nil;
    self.activeImage = nil;
}
@end 


