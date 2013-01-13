//
//  SCNProductImageModeTableCell.m
//  SCN
//
//  Created by xie xu on 11-10-11.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductImageModeTableCell.h"

@interface SCNProductImageModeTableCell(private)

- (void)contextMiddlePathWith:(CGContextRef)_context Rect:(CGRect)_rect;
- (void)drawGradientWith:(CGContextRef)_context Rect:(CGRect)_rect;

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;

@end


@implementation SCNProductImageModeTableCell
@synthesize m_imageView_product_left;
@synthesize m_label_product_name_left;
@synthesize m_label_product_marketPrice_left;
@synthesize m_label_product_sellPrice_left;
@synthesize m_imageView_product_right;
@synthesize m_label_product_name_right;
@synthesize m_label_product_marketPrice_right;
@synthesize m_label_product_sellPrice_right;
@synthesize m_button_product_left;
@synthesize m_button_product_right;
@synthesize m_label_product_type1_left;
@synthesize m_label_product_type2_left;
@synthesize m_view_left;
@synthesize m_label_product_type1_right;
@synthesize m_label_product_type2_right;
@synthesize m_view_right;

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    if(self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
    }
    return self;
}
-(void)dealloc{
    [m_imageView_product_left release];m_imageView_product_left=nil;
    [m_label_product_marketPrice_left release];m_label_product_marketPrice_left=nil;
    [m_label_product_name_left release];m_label_product_name_left=nil;
    [m_label_product_sellPrice_left release];m_label_product_sellPrice_left=nil;
    [m_label_product_type1_left release];m_label_product_type1_left=nil;
    [m_label_product_type2_left release];m_label_product_type2_left=nil;
    [m_view_left release];m_view_left=nil;
    [m_imageView_product_right release];m_imageView_product_right=nil;
    [m_label_product_marketPrice_right release];m_label_product_marketPrice_right=nil;
    [m_label_product_name_right release];m_label_product_name_right=nil;
    [m_label_product_sellPrice_right release];m_label_product_sellPrice_right=nil;
    [m_label_product_type1_right release];m_label_product_type1_right=nil;
    [m_label_product_type2_right release];m_label_product_type2_right=nil;
    [m_view_right release];m_view_right=nil;
    [super dealloc];
}

-(void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawGradientWith:context Rect:rect];
	
}

- (void)drawGradientWith:(CGContextRef)_context Rect:(CGRect)_rect
{
	CGContextSaveGState(_context);
	[self contextMiddlePathWith:_context Rect:_rect];
	CGContextClip(_context);
	
	UIColor* colors[] = {[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]};
	CGGradientRef _gradient = [self newGradientWithColors:colors locations:nil count:2];
	CGContextDrawLinearGradient(_context, _gradient, CGPointZero, CGPointMake(_rect.origin.x, _rect.origin.y+_rect.size.height), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(_gradient);
	
	CGContextRestoreGState(_context);
}

- (void)contextMiddlePathWith:(CGContextRef)_context Rect:(CGRect)_rect
{
	//_rect = CGRectMake(_rect.origin.x, _rect.origin.y, _rect.size.width - SHADOW_OFFSET_X, _rect.size.height - 1.0);
	
	CGFloat minx = CGRectGetMinX(_rect) , maxx = CGRectGetMaxX(_rect) ;
	CGFloat miny = CGRectGetMinY(_rect) , maxy = CGRectGetMaxY(_rect) ;
	
	CGContextMoveToPoint(_context, minx, miny);
	CGContextAddLineToPoint(_context, maxx, miny);
	CGContextAddLineToPoint(_context, maxx, maxy);
	CGContextAddLineToPoint(_context, minx, maxy);
	
	CGContextClosePath(_context);
}

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations
								 count:(int)count {
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef _gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
	free(components);
	return _gradient;
}

@end
