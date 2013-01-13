//
//  YK_OnSelectedButton.m
//  m5173
//
//  Created by Guwei.Z on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_OnSelectedButton.h"


@implementation YK_OnSelectedButton


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event]; 
	if ( self.selected == NO ) {
		[self setSelected:YES];
	}else {
		[self setSelected:NO];
	}
}



@end
