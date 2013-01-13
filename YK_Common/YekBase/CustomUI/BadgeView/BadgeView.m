//
//  BadgeView.m
//  USHI
//
//  Created by Mac on 10-1-12.
//  Copyright 2010 yek.com All rights reserved.
//

#import "BadgeView.h"
#import "HJImageUtility.h"
@implementation BadgeView
@synthesize badgeValue;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		nums = [NSMutableArray array];
		
		UIImage* image =[HJImageUtility getUIImage:@"number_bg.png"];
		bg_img = [image stretchableImageWithLeftCapWidth:16.5 topCapHeight:0.0];

		iv_bg=[[UIImageView alloc]initWithImage:bg_img];
	
		for(int i=0;i<10;i++)
		{
			[nums addObject:[HJImageUtility getUIImage:[NSString stringWithFormat:@"num%d.png",i]]];
		}
		[self setUserInteractionEnabled: NO];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	[[UIColor whiteColor] set];
	NSString *str=[NSString stringWithFormat:@"%d",badgeValue];
	UIFont * font = [UIFont boldSystemFontOfSize:14.0f];
	
	CGFloat width = str.length * 8;
	CGFloat imagewidth = width +20;
	imagewidth = imagewidth > 33 ? imagewidth : 33;
	[bg_img drawInRect:CGRectMake(0, 0, imagewidth, 33)];
	[str drawInRect:CGRectMake((imagewidth - width) / 2,4, width, 33) withFont:font];
	
//	if (badgeValue == 0)
//		return;
//	if(badgeValue>=1000)
//	{
//		[(UIImage *)[nums objectAtIndex:badgeValue/1000] drawAtPoint:CGPointMake(5,8)];
//		[(UIImage *)[nums objectAtIndex:(badgeValue-(badgeValue/1000)*1000)/100] drawAtPoint:CGPointMake(13,8)];
//		[(UIImage *)[nums objectAtIndex:(badgeValue-(badgeValue/100)*100)/10] drawAtPoint:CGPointMake(19,8)];
//		[(UIImage *)[nums objectAtIndex:badgeValue-(badgeValue/10)*10] drawAtPoint:CGPointMake(26,8)];
//	}
//	else if(badgeValue>=100)
//	{
//		
//		
//		[(UIImage *)[nums objectAtIndex:badgeValue/100] drawAtPoint:CGPointMake(13,8)];
//		[(UIImage *)[nums objectAtIndex:(badgeValue-(badgeValue/100)*100)/10] drawAtPoint:CGPointMake(21,8)];
//		[(UIImage *)[nums objectAtIndex:badgeValue-(badgeValue/10)*10] drawAtPoint:CGPointMake(29,8)];
//	}
//	else if(badgeValue>=10)
//	{
//		[bg_img drawInRect:CGRectMake(0, 0, 40, 33)];
//		[(UIImage *)[nums objectAtIndex:badgeValue/10] drawAtPoint:CGPointMake(13,8)];
//		[(UIImage *)[nums objectAtIndex:badgeValue-(badgeValue/10)*10] drawAtPoint:CGPointMake(21,8)];
//	}
//	else if(badgeValue>0)
//	{
//		[bg_img drawAtPoint:CGPointMake(0,0)];
//		[(UIImage *)[nums objectAtIndex:badgeValue] drawAtPoint:CGPointMake(13,8)];
//	}
	
	
	
}

-(void)setBadge:(int)_badgeValue
{
	badgeValue=_badgeValue;
	[self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.nextResponder touchesBegan:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.nextResponder touchesMoved:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.nextResponder touchesEnded:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.nextResponder touchesCancelled:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}
- (void)dealloc {
	for (UIView *view in [self subviews]) {
		[view removeFromSuperview];
	}
	[self removeFromSuperview];
}


@end
