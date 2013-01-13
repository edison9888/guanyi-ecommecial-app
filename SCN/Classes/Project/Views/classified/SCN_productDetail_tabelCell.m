//
//  SCN_productDetail_tabelCell.m
//  SCN
//
//  Created by admin on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCN_productDetail_tabelCell.h"
// 显示商品图片
@implementation TopView

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([self pointInside:point withEvent:event])
	{
		UIView* view = [self viewWithTag:10];
		UIView* tmpview = [view hitTest:[self convertPoint:point toView:view] withEvent:event];
        return tmpview ? tmpview : view;
	}
	return nil;
}

@end

@implementation SCN_productDetail_tabelCell_First

@synthesize m_topView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    m_topView = nil;
}
@end


// 商品名和价格
@implementation SCN_productDetail_tabelCell_Second

@synthesize m_nameLable,m_marketPriceLable,m_sellPriceLable;//m_styleLable,
@synthesize m_saleOneLable,m_saleTwoLable,m_sellLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    m_nameLable = nil;
//    [m_styleLable release],m_styleLable = nil;
    m_marketPriceLable = nil;
    m_sellPriceLable = nil;
    
    m_saleOneLable = nil;
    m_saleTwoLable = nil;
    m_sellLable = nil;
    
}

@end


// 更多商品信息
@implementation SCN_productDetail_tabelCell_More

@synthesize m_descLable,m_backImageV;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    
    m_descLable = nil;
    m_backImageV = nil;
}

@end


//颜色 尺码 数量
@implementation SCN_productDetail_tabelCell_Color

@synthesize m_colorLayoutView,m_sizeLayutView;
@synthesize m_colorFrontButton,m_colorBehindButton,m_sizeFrontButton,m_sizeBehindButton,m_addCountButton,m_cutCountButton,m_sizeSwitch;
@synthesize m_countsTextField,m_disCountLable; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    m_colorLayoutView = nil;
    m_sizeLayutView = nil;
    
    m_colorFrontButton = nil;
    m_colorBehindButton = nil;
    
    m_sizeFrontButton = nil;
    m_sizeBehindButton = nil;
    
    m_addCountButton = nil;
    m_cutCountButton = nil;
    
    m_sizeSwitch = nil;
    
    m_countsTextField = nil;
    
    m_disCountLable = nil;
}

@end


@implementation SCN_productDetail_tabelCell_Size
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end


@implementation SCN_productDetail_tabelCell_Count
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


@end


// 加入购物车
@implementation SCN_productDetail_tabelCell_Buy

@synthesize m_buyImmediatelyButton,m_addShopCarButton,m_addfavoriteButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    m_buyImmediatelyButton = nil;
    m_addShopCarButton = nil;
    m_addfavoriteButton = nil;
    
}

@end


@implementation share_CustomButton
@synthesize shareUrl;
-(void)dealloc{
    shareUrl = nil;
}
@end

//分享
@implementation SCN_productDetail_tabelCell_Share

@synthesize m_shareSinaButton,m_shareTXButton,m_shareMailButton,m_shareNoteButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)dealloc {
    m_shareSinaButton = nil;
    m_shareTXButton = nil;
    m_shareMailButton = nil;
    m_shareNoteButton = nil;
}

@end

