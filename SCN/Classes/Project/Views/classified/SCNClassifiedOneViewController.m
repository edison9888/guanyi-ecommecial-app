//
//  SCNClassifiedOneViewController.m
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2011 Yek.me. All rights reserved.
//

#import "SCNClassifiedOneViewController.h"
//#import "SCNClassifiedTwoViewController.h"
#import "SCN_productDetailViewController.h"
#import "HJManagedImageV.h"
#import "HJImageUtility.h"

@implementation SCNClassifiedOneViewController

@synthesize m_tableview;
@synthesize m_OneClassifiedId;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil withFirstClassifiedId:(NSString*)string bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_OneClassifiedId = string;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.m_OneClassifiedId;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.m_tableview = nil;
}


- (void)dealloc {
	
	[m_tableview release];
    [m_OneClassifiedId release];
    [super dealloc];
}

#pragma mark －
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString *CellIdentifier = @"ClassifiedOneTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	int index = indexPath.row;
	NSString *string = [NSString stringWithFormat:@"二级分类%@",[NSNumber numberWithInt:index]];
	cell.textLabel.text = string;
    //    HJManagedImageV *leftIcon = [[HJManagedImageV alloc] initWithFrame:CGRectMake(5.0f, 5.0, 50.0f, 50.0f)];
    //    [cell.contentView addSubview:leftIcon];
    //    [HJImageUtility queueLoadImageFromUrl:@"TabBar_3_SEL.png" imageView:leftIcon];
    cell.imageView.image = [UIImage imageNamed:@"TabBar_3_SEL.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    SCN_productDetailViewController *productDetail = [[SCN_productDetailViewController alloc] initWithNibName:@"SCN_productDetailViewController" bundle:nil];
    [self.navigationController pushViewController:productDetail animated:YES];
    [productDetail release];
    /*
    int index = indexPath.row;
	NSString *string = [NSString stringWithFormat:@"二级分类%@",[NSNumber numberWithInt:index]];
	SCNClassifiedOneViewController *classifiedTwo = [[SCNClassifiedOneViewController alloc] initWithNibName:@"SCNClassifiedOneViewController" withFirstClassifiedId:string  bundle:nil];
	[self.navigationController pushViewController:classifiedTwo animated:YES];
	[classifiedTwo release];
     */
}

@end
