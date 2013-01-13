//
//  TextBlock.m
//  YesMyWine
//
//  Created by zwh on 11-7-8.
//  Copyright 2011 yek.com All rights reserved.
//

#import "TextBlock.h"


@implementation TextBlock

- (id)init
{
    if (self = [super init]) 
	{
		self.numberOfLines=0;
		self.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
	{
		self.numberOfLines=0;
		self.lineBreakMode = UILineBreakModeWordWrap;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
	{
		self.numberOfLines=0;
		self.lineBreakMode = UILineBreakModeWordWrap;
	}
    return self;
}

-(void)adjustSizeByStr:(NSString*) string
{
	if(self.numberOfLines == 0)
	{
		CGRect oldsize = self.frame;
		CGSize strSize=[string sizeWithFont:self.font constrainedToSize:CGSizeMake(oldsize.size.width, MAXFLOAT) lineBreakMode:self.lineBreakMode];	
		self.frame=CGRectMake(oldsize.origin.x, oldsize.origin.y, oldsize.size.width, strSize.height);
	}
}

-(void)setText:(NSString *)string
{
	[self adjustSizeByStr:string];
	[super setText:string];
}

-(void)adjustSize
{
	[self adjustSizeByStr:self.text];
}

-(void)setFrame:(CGRect)rect
{
	if (self.numberOfLines == 0)
	{
		CGRect oldframe = self.frame;
		if (oldframe.size.width != oldframe.size.width)
		{
			[super setFrame:rect];
			[self adjustSize];
			return;
		}
	}
	[super setFrame:rect];
}




@end
