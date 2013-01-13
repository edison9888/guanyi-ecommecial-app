//
//  YKBaseClassfiedListController.m
//  YKProject
//
//  Created by guwei.zhou on 11-9-27.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKBaseClassfiedListController.h"
#import "YK_TableViewUtility.h"

static NSString* cellIdentifier = @"YKClassfiedCellIdentifier";

@implementation YKBaseClassfiedListController
@synthesize m_tableView;
@synthesize m_array_classfied;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if ( self.m_array_classfied == nil ) {
        [self startAsyncWebData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.m_tableView = nil;
    self.m_array_classfied = nil;
}

- (void)dealloc{
    [m_array_classfied release];
    [m_tableView release];
    [super dealloc];
}

#pragma mark - 网络请求部分

-(void)startAsyncWebData{
    assert(NO);
}

-(void)reAsyncWebData{
    self.m_array_classfied = nil;
    [self startAsyncWebData];
}

-(void)onStartAsyncWebData:(NSObject*)response{
    assert(NO);
}

-(void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    assert(NO);
}

-(void)reloadData{    
    [m_tableView reloadData];
}

-(void)reloadDataOnThread{
    [self performSelectorInBackground:@selector(reloadData) withObject:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [self cellAtIndexPath:indexPath withIdentifier:cellIdentifier];
    }else{
        NSLog(@"[SYS]%@ reused", [cell reuseIdentifier] );
    }
    
    [self layoutCellUI:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [m_array_classfied count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell frame].size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DEFAULT_LIST_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return DEFAULT_LIST_FOOTER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRowAtIndexPath:indexPath];
}

@end
