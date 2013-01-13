//
//  TKCustomMiddleLineLable.m
//  BanggoMall
//
//  Created by Guwei.Z on 11-2-26.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YKCustomMiddleLineLable.h"


@implementation YKCustomMiddleLineLable

@synthesize enabled_middleLine;

- (void)drawRect:(CGRect)rect {
	
	if ( enabled_middleLine == YES) {
		CGSize sizeToDraw = [self.text sizeWithFont:self.font];
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSetRGBStrokeColor(ctx, 152.0/255.0, 154.0/255.0, 158.0/255.0, 1.0f); // RGBA
		CGContextSetLineWidth(ctx, 1.0f);
		float x_start = 0 ;
		if ( self.textAlignment == UITextAlignmentLeft) {
			x_start = 0;
		}else if ( self.textAlignment == UITextAlignmentCenter) {
			x_start = ( self.bounds.size.width-sizeToDraw.width )/2;
		}else if ( self.textAlignment == UITextAlignmentRight){
			x_start = ( self.bounds.size.width-sizeToDraw.width );
		}

		CGContextMoveToPoint(ctx, x_start, self.bounds.size.height/2 );
		CGContextAddLineToPoint(ctx, sizeToDraw.width+x_start, self.bounds.size.height/2 );
		
		CGContextStrokePath(ctx);
	} 
    [super drawRect:rect];  
}

@end
