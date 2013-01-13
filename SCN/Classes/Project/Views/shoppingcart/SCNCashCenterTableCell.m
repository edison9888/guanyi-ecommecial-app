//
//  SCNCashCenterTableCell.m
//  SCN
//
//  Created by huangwei on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCashCenterTableCell.h"


@implementation SCNCashCenterOrderInfoTableCell
@synthesize m_labTotalAmount;
@synthesize m_labCarrige;
@synthesize m_labPreferentAmount;
@synthesize m_labPreferentAmountTxt;
@synthesize m_labMobileSave;
@synthesize m_labMobileSaveTxt;
@synthesize m_imgSepar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

@implementation SCNCashCenterOrderInfoDownTableCell
@synthesize m_labPayAmount;
@synthesize m_labProductCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

@implementation SCNCashCenterNoReceiveInfoTableCell
@synthesize m_labAddAddress;
@synthesize m_btnAddAddress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

@end


#pragma mark-
#pragma mark SCNCashCenterReceiveInfoTableCell
@implementation SCNCashCenterReceiveInfoTableCell
@synthesize m_labAddress;
@synthesize m_labName;
@synthesize m_labMobile;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

@end

#pragma mark-
#pragma mark SCNCashCenterPayShippingUpTableCell
@implementation SCNCashCenterPayShippingUpTableCell
@synthesize m_labPayMethod;
@synthesize m_imgTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

@end

#pragma mark-
#pragma mark SCNCashCenterPayShippingDownTableCell
@implementation SCNCashCenterPayShippingDownTableCell
@synthesize m_labUseCoupon;
@synthesize m_btnCouponSelect;
@synthesize m_labUseResult;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

#pragma mark-
#pragma mark SCNCashCenterAskInvoiceTableCell
@implementation SCNCashCenterAskInvoiceTableCell
@synthesize m_labAskInvoiceTxt;
@synthesize m_btnAskInvoiceMore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

#pragma mark-
#pragma mark SCNCashCenterMessageTableCell
@implementation SCNCashCenterMessageTableCell
@synthesize m_labMessageTxt;
@synthesize m_txtViewMessage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

#pragma mark-
#pragma mark SCNCashCenterCouponPopTableCell
@implementation SCNCashCenterCouponPopTableCell
@synthesize m_labCoupon;
@synthesize m_btnCouponSelect;
@synthesize m_btnCouponCancel;
@synthesize m_btnTouch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

#pragma mark-
#pragma mark SCNCashCenterSuccessTableCell
@implementation SCNCashCenterSuccessTableCell
@synthesize m_labOrderId;
@synthesize m_labOrderPrice;
@synthesize m_labPayMethod;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end

@implementation SCNCashCenterTableCell
@synthesize m_imgBack;
@synthesize m_image;
@synthesize m_labName;
@synthesize m_labStyle;
@synthesize m_labNumber;
@synthesize m_labPriceTitle;
@synthesize m_labPriceValue;
@synthesize m_labSaveTitle;
@synthesize m_labSaveValue;
@synthesize m_txtNumber;
@synthesize m_imgArrow;
@synthesize m_labTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end


