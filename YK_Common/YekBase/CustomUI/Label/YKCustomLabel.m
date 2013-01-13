//
//  YKCustomLabel.m
//  MoonbasaIpad
//
//  Created by zhi.zhu on 11-9-16.
//  Copyright 2011 Yek. All rights reserved.
//

#import "YKCustomLabel.h"


@implementation YKCustomLabel

@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        self.verticalAlignment = VerticalAlignmentTop;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
	verticalAlignment_ = verticalAlignment;
	[self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	switch (self.verticalAlignment) {
		case VerticalAlignmentTop:
			textRect.origin.y = bounds.origin.y;
			break;
		case VerticalAlignmentBottom:
			textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
			break;
		case VerticalAlignmentMiddle:
			// Fall through.
		default:
			textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
	}
	return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
	CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:actualRect];
}
@end
