//
//  SCNHelpViewController.m
//  SCN
//
//  Created by chenjie on 11-9-30.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNHelpViewController.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNHelpData.h"
#import "SCNHelpinfoViewController.h"

@implementation SCNHelpViewController


- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.m_tableview_help = nil;
	self.m_helpArray = nil;
    [self resetDataSource];
}

-(void)resetDataSource
{
    m_isRequestsuccess = NO;
    [self.m_helpArray removeAllObjects];
    [self.m_tableview_help reloadData];

}
- (void)dealloc
{
    NSLog(@"帮助页面dealloc调用");
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_isRequestsuccess) 
	{
        [self.m_tableview_help setHidden:YES];
        [self requestHelp];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YKHttpAPIHelper cancelAllRequest];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮助";
	self.pathPath = @"/other";
    self.m_helpArray = [@[] mutableCopy];
	m_isRequestsuccess = NO;
    
}
-(void)requestHelp
{
    if (m_isRequesting) {
        return;
    }
    m_isRequesting = YES;
    [self startLoading];
    
    NSString* v_method = [YKStringUtility strOrEmpty:MMUSE_METHOD_GET_HELPLIST];
    NSDictionary* extraParam= @{@"method": v_method};
    
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseHelp:)];

}

-(void)onResponseHelp:(id)json_obj
{
    [self stopLoading];
    m_isRequesting = NO;
    
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) {
        m_isRequestsuccess = YES;
        
        self.m_helpArray = [[[GY_Collection_Help alloc]initWithJSON:json_obj] arr_dict_help_infos];
        
        if ([self.m_helpArray count] > 0) {
            [self.m_tableview_help setHidden:NO];
            [self.m_tableview_help reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_helpArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
		
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier];
        

	    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    NSMutableDictionary* _data_info = [self.m_helpArray objectAtIndex:[indexPath row]];
    
    UILabel * _label_help = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 270, 20)];
    _label_help.text = [_data_info objectForKey:@"name"];
    _label_help.backgroundColor = [UIColor clearColor];
    _label_help.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:_label_help];
    
    cell.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* _data_info = [self.m_helpArray objectAtIndex:[indexPath row]];
    
    SCNHelpinfoViewController * helpinfo_viewCtrl = [[SCNHelpinfoViewController alloc] initWithNibName:@"SCNHelpinfoViewController" bundle:nil helpinfo:_data_info];
    [self.navigationController pushViewController:helpinfo_viewCtrl animated:YES];
 
}


@end
