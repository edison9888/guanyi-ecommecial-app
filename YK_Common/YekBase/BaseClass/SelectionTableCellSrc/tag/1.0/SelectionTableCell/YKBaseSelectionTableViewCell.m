//
//  YKBaseSelectionTableViewCell.m
//  testYKLiNing
//
//  Created by guwei.zhou on 11-9-29.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKBaseSelectionTableViewCell.h"

@implementation YKBaseSelectionTableViewCell
@synthesize m_imageView_icon;
@synthesize m_label_title;
@synthesize m_id;

-(void)setM_cellType:(YK_TABLECELL_TYPE)cellType{
    m_cellType = cellType;
    [self layoutUI];
}

-(YK_TABLECELL_TYPE)m_cellType{
    return m_cellType;
}

-(void)layoutUI{
    
    self.frame = CGRectMake(0, 0, DEFAULT_CELL_WIDTH, DEFAULT_CELL_HEIGHT);
    
    if ( m_cellType == IMAGECELL ) {
        m_imageView_icon.frame = CGRectMake(DEFAULT_ICON_ORIGINAL_X, DEFAULT_ICON_ORIGINAL_Y, DEFAULT_ICON_WIDTH, DEFAULT_ICON_HEIGHT);
        
        m_label_title.frame = CGRectMake(DEFAULT_TITLE_ORIGINAL_X, DEFAULT_TITLE_ORIGINAL_Y, DEFAULT_TITLE_WIDTH, DEFAULT_TITLE_HEIGHT);
    }else if ( m_cellType == TEXTCELL ){
        m_imageView_icon.hidden = YES;
        /*
         居中算法
         */
        int titleWidth = self.frame.size.width*0.9;
        
        m_label_title.frame = CGRectMake( (self.frame.size.width - titleWidth)/2, (self.frame.size.height - DEFAULT_TITLE_HEIGHT)/2, titleWidth, DEFAULT_TITLE_HEIGHT);
    }
}

-(void)initUI{
    
    UIImage* defaultIconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForAuxiliaryExecutable:DEFAULT_ICONPATH]];
    
    m_imageView_icon = [[HJManagedImageV alloc] initWithImage:defaultIconImage];
    
    [defaultIconImage release];
    
    m_imageView_icon.layer.cornerRadius = DEFAULT_CORNER_RADIUS;
    
    m_imageView_icon.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    
    [self addSubview:m_imageView_icon];
    
    m_label_title = [[UILabel alloc] init];
    [m_label_title setBackgroundColor:[UIColor clearColor]];
    [self addSubview:m_label_title];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [self layoutUI]; //在此处设置默认布局
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	[super setSelected:selected animated:animated];
	
    if ( selected ) {
	}else {
		UIImage* highLightImage = [UIImage imageNamed:BACKGROUND_HIGHLIGHT_IMAGEPATH];
		[self setSelectedBackgroundView:[[[UIImageView alloc] initWithImage:highLightImage] autorelease]];
	}
}

-(void)drawRect:(CGRect)rect{
	if ( [self isSelected] == NO ) {
		[[UIImage imageNamed:BACKGROUND_IMAGEPATH] drawInRect:rect];
	}
}

-(void)dealloc{
    [m_imageView_icon release];
    [m_label_title release];
    [m_id release];
    [super dealloc];
}

@end
