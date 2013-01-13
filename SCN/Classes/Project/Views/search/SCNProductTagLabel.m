//
//  SCNProductTagLabel.m
//  SCN
//
//  Created by xie xu on 11-10-20.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductTagLabel.h"

@implementation SCNProductTagLabel
@synthesize isleft;

-(void)setText:(NSString *)text{
    [self setBackgroundColor: [UIColor clearColor]];
    self.textColor=[UIColor whiteColor];
	self.highlightedTextColor = [UIColor whiteColor];
    self.layer.cornerRadius=2.5;
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT,MAXFLOAT);
    CGSize expectedLabelSize = [text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
    CGRect rect = self.frame;
    if (!self.isleft) {
        rect.origin.x = CGRectGetMaxX(rect) - expectedLabelSize.width;
    }
    rect.size.width=expectedLabelSize.width;
    
    self.frame=rect;

    [super setText:text];
}

-(void)drawRect:(CGRect)rect
{
	CGContextRef _context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(_context);
	
	CGColorRef color = [UIColor colorWithRed:192.0/255 green:17.0/255 blue:17.0/255 alpha:1].CGColor;
	
	CGContextSetFillColorWithColor(_context, color);
	CGContextFillRect(_context, rect);
	
	CGContextRestoreGState(_context);
	
	[super drawRect:rect];
}

@end
