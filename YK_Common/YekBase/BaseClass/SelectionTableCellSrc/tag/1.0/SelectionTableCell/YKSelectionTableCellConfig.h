//
//  YKSelectionTableCellConfig.h
//  testYKLiNing
//
//  Created by guwei.zhou on 11-9-29.
//  Copyright 2011年 yek. All rights reserved.
//

/*
 此处参照梦芭莎的大小和位移设置
 */
#define DEFAULT_ICON_WIDTH 66
#define DEFAULT_ICON_HEIGHT 66

#define DEFAULT_ICON_ORIGINAL_X 10
#define DEFAULT_ICON_ORIGINAL_Y 3

#define DEFAULT_TITLE_WIDTH 203
#define DEFAULT_TITLE_HEIGHT 29

#define DEFAULT_TITLE_ORIGINAL_X 97
#define DEFAULT_TITLE_ORIGINAL_Y 22

#define DEFAULT_CELL_WIDTH 320
#define DEFAULT_CELL_HEIGHT 72

#define DEFAULT_CORNER_RADIUS 3.0f
#define DEFAULT_BORDER_WIDTH 1.0f

extern NSString* BACKGROUND_IMAGEPATH;
extern NSString* BACKGROUND_HIGHLIGHT_IMAGEPATH;
extern NSString* DEFAULT_ICONPATH;

typedef enum TABLECELL_TYPE{
    IMAGECELL,
    TEXTCELL
} YK_TABLECELL_TYPE;