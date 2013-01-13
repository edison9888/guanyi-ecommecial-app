//
//  SCNLogisticsTrackingViewController.m
//  SCN
//
//  Created by user on 11-11-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNLogisticsTrackingViewController.h"


@implementation SCNLogisticsTrackingViewController
@synthesize m_str_logisticsTrack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil logistics: (NSString *)logistics
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_str_logisticsTrack = logistics;
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"物流追踪";
	self.pathPath = @"/other";
    NSURL * url =[NSURL URLWithString:[NSString stringWithFormat:@""]];
    self.view.backgroundColor  = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
    [m_webview_logistics.layer setCornerRadius:5];
    m_webview_logistics.layer.backgroundColor = [UIColor clearColor].CGColor;
    [m_webview_logistics loadHTMLString:m_str_logisticsTrack baseURL: url];
    m_webview_logistics.layer.borderColor = [UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor;
    [m_webview_logistics.layer setCornerRadius:5];
    //设置边框宽度
    [m_webview_logistics.layer setBorderWidth:1];
    m_webview_logistics.layer.masksToBounds = YES ;
}

@end
