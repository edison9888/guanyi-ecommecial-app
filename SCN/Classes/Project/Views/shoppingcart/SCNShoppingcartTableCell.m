//
//  SCNShoppingcartTableCell.m
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNShoppingcartTableCell.h"


@implementation SCNShoppingcartTableCell
@synthesize m_image;
@synthesize m_name;
@synthesize m_size;
@synthesize m_color;
@synthesize m_number;
@synthesize m_unitPrice;
@synthesize m_preferential;
@synthesize m_btnMoreFun;
@synthesize m_txtNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


-(void)willTransitionToState:(UITableViewCellStateMask)state {
	
    [super willTransitionToState:state];
	
	if (state & UITableViewCellStateEditingMask) {
		m_txtNumber.enabled=YES;
		m_txtNumber.hidden = NO;
		m_number.hidden = YES;
		[m_txtNumber setBorderStyle:UITextBorderStyleLine];
		
	}
	
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
	[super didTransitionToState:state];
	if (!(state & UITableViewCellStateEditingMask)) {
		m_txtNumber.enabled=NO;
		m_number.hidden = NO;
		m_txtNumber.hidden = YES;
		[m_txtNumber setBorderStyle:UITextBorderStyleNone];
		
		
	}
	
}


@end

@implementation SCNShoppingcartTableHeadCell
@synthesize m_originalPrice;
@synthesize m_preferentailPrice;
@synthesize m_totalPrice;
@synthesize m_productNumber;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

@end

@implementation SCNShoppingcartNameValueTableCell
@synthesize m_labName;
@synthesize m_labValue;
@synthesize m_imgSepar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		}
    return self;
}


@end


