

#import <QuartzCore/QuartzCore.h>
#import "SCNHelpinfoViewController.h"
#import "TextBlock.h"

#define  LABELTAG_TITLE        100

@implementation SCNHelpinfoViewController

@synthesize m_webview_helpinfo;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             helpinfo:(NSMutableDictionary*)helpinfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.m_data_helpinfo = (NSMutableDictionary *)helpinfo;
        
    }
    return self;
}

- (void)dealloc
{  
    NSLog(@"帮助详情界面dealloc调用");
}
- (void)viewDidUnload
{
    self.m_webview_helpinfo = nil;
    [super viewDidUnload];  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助详情";
    self.pathPath = @"/other";
    [self setBackText:@"返回"];
//    UIScrollView * scrollview_bgview = (UIScrollView *)self.view;
   
    
    UILabel * _label_title = (UILabel *) [self.view viewWithTag:LABELTAG_TITLE];
    _label_title.text = [self.m_data_helpinfo objectForKey:@"name"];
    
    self.view.backgroundColor  = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1];
    NSURL * url = [NSURL URLWithString:@""];
    [m_webview_helpinfo loadHTMLString:[self.m_data_helpinfo objectForKey:@"content"] baseURL: url];
    [m_webview_helpinfo.layer setCornerRadius:5];
    m_webview_helpinfo.layer.backgroundColor = [UIColor clearColor].CGColor;
    m_webview_helpinfo.layer.borderColor = [UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor;
    [m_webview_helpinfo.layer setCornerRadius:5];
    //设置边框宽度
    [m_webview_helpinfo.layer setBorderWidth:1];
    m_webview_helpinfo.layer.masksToBounds = YES ;
    m_webview_helpinfo.userInteractionEnabled = YES;
    m_webview_helpinfo.multipleTouchEnabled = YES;
}



@end
