//
//  SCNUserCommentaryTableCell.m
//  SCN
//
//  Created by user on 11-10-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNUserCommentaryTableCell.h"


@implementation SCNUserCommentaryTableCell
@synthesize m_label_info
,m_label_content
,m_button_publish
,m_imageview_info
,m_label_creatTime
,m_view_bgviewinfo
,m_label_commentaryClass
,m_label_commentaryNumber
,m_view_bgcommentaryCell
,m_imageview_star
,m_babel_titlename
,m_label_page
,m_label_username
,m_SCNImageview;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}



@end
