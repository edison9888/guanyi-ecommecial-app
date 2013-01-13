//
//  SCNAddressTableCell.m
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNAddressTableCell.h"


@implementation SCNAddressListTableCell
@synthesize m_labAddress;
@synthesize m_labName;
@synthesize m_labMobile;
@synthesize m_labArea;
@synthesize m_imageArrow;
@synthesize m_labDefault;
@synthesize m_imageDefaultBox;
@synthesize m_imageDefaultArrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

@implementation AddressEditTableCell_DefaultKeyBoard
@synthesize m_int_row;
@synthesize m_label;
@synthesize m_textField;


@end

@implementation AddressEditTableCell_Phone
@synthesize m_int_row;
@synthesize m_label;
@synthesize m_textField;


@end

@implementation MorelacalEditTableCell_Edit


@synthesize m_lable_key;
@synthesize m_TextField_value;

@end


@implementation MorelacalEditTableCell_Edit_One


@synthesize m_lable_key;
@synthesize m_TextField_value;

@end
