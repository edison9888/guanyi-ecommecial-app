
#import "SCNAboutViewController.h"
#import "YKStringHelper.h"
#import "YKButtonUtility.h"
#define HEIGHT   185.0f   

@implementation SCNAboutViewController



- (void)dealloc
{
    NSLog(@"关于界面dealloc调用");
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"关于";
    self.pathPath = @"/other";
	
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, HEIGHT-108.0f, 200.0f, 55.0f)];
    title.backgroundColor = [UIColor clearColor];
    title.text = [NSString stringWithFormat:@"名鞋库 for iPhone"];
	title.textColor = [UIColor darkGrayColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = UITextAlignmentCenter;
    title.numberOfLines = 2;
    title.lineBreakMode = UILineBreakModeCharacterWrap;
//  title.font =[UIFont fontWithName:@"黑体-简" size:18]; 
    
    UIImage *image = [UIImage imageNamed:@"more_about.png"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake((self.view.frame.size.width-239)/2,140.0f , 239.0f, 38.0f);
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, HEIGHT+20.0f, 300.0f, 45.0f)];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:12];
    content.textAlignment = UITextAlignmentCenter;
    content.text = [NSString stringWithFormat:@"Copyright © 2012 谬诗"];
	content.textColor = [UIColor darkGrayColor];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-200)/2, HEIGHT+60.0f, 200.0f, 40.0f)];
    version.backgroundColor =  [UIColor clearColor];
    version.font = [UIFont systemFontOfSize:12];
    version.textAlignment = UITextAlignmentCenter;
    NSString* appver=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	if(!stringIsEmpty(appver)){
		version.text=[NSString stringWithFormat:@"版本号: %@",appver];
	}
	
	[self.view addSubview:imageview];
	[self.view addSubview:version];
	[self.view addSubview:title];
	[self.view addSubview:content];
	

}




@end
