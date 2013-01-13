//
//  YKBaseListViewController.m
//  YKProject
//
//  Created by guwei.zhou on 11-9-26.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKBasePageListViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "YK_TableViewUtility.h"

static NSString *loadingCellIdentifier = @"YKListLoadingTipsCell";
static NSString *itemCellIdentifier = @"YKListItemCell";

@implementation YKBasePageListViewController

@synthesize  m_page;
@synthesize  m_pageCount;
@synthesize  m_pageSize;
@synthesize  m_itemsCount;
@synthesize  isadd;
@synthesize  _refreshHeaderView;
@synthesize  _reloading;
@synthesize  m_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  isadd:(EGORefresh)addEGORefresh{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self) {
	   self.isadd=addEGORefresh;
   }
 return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark frame set
-(void)restrictTableViewArea:(CGSize)areaSize{
    [self.view setFrame:CGRectMake(0, 0, areaSize.width, areaSize.height)];
}

#pragma mark - setter and getter
-(NSMutableArray*)listItems{
    return _array_listData;
}
-(void)setListItems:(NSMutableArray*)listArray{
    [_array_listData release];
    _array_listData = [listArray retain];
}

#pragma mark webRequest
-(void)startAsyncWebData{
    assert(NO);//必须重写
}

-(void)reAsyncWebData{
	
    m_page = 0;
    m_pageCount = 1;
	
	[_array_listData removeAllObjects];
	
	m_itemsCount = [_array_listData count];
	
	[self reloadData];
}

-(void)reloadData{
    [m_tableView reloadData];
}

-(void)onStartAsyncWebData:(NSObject*)response{
    assert(NO);//必须重写
}

#pragma mark Data
-(int)cellsSectionNumber{
    return DEFAULT_LIST_SECTION_NUMBER;
}

-(void)reloadDataOnThread{
    [self performSelectorInBackground:@selector(reloadData) withObject:nil];
}

-(void)appendData:(NSArray*)items{
	
    int baseCount = [[self listItems] count];
    
    NSMutableArray* indexPathsArray = [[NSMutableArray alloc] initWithCapacity:[items count]];
    
    for ( int i = 0; i < [items count]; i++ ) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:baseCount + i inSection:0];
        
		[indexPathsArray addObject:indexPath];
        
		[[self listItems] addObject:[items objectAtIndex:i]];
    }
    
    m_itemsCount = [[self listItems] count];
    
    [m_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
   
	[indexPathsArray release];
    
    NSLog( @"[BIZ]page:%d pageCount:%d", m_page, m_pageCount );
    
    if ( m_page == m_pageCount ) {
        m_itemsCount--;
        [m_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self listItems] count] inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void)appendDataOnThread:(NSArray*)items{
    [self performSelectorInBackground:@selector(appendData:) withObject:items];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _array_listData = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self reloadData];
	
	switch (isadd) {
		case defaultenum:
			break;
		case first:
		[self CreateEGORefreshTableHeaderView];
			break;
		default:
			break;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listItems = nil;
    self.m_tableView = nil;
}

- (void)dealloc{
    [_array_listData release];
    [m_tableView release];
    [super dealloc];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self cellsSectionNumber];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_itemsCount+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLoadingCell=(indexPath.row==[[self listItems] count]);
    NSString* cellIdentifier = isLoadingCell?loadingCellIdentifier:itemCellIdentifier;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( isLoadingCell ) {
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
            cell.textLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
            cell.textLabel.text = @"正在加载...";
        }else{
            NSLog(@"[SYS]%@ reused", [cell reuseIdentifier] );
        }
    }else{
        if (cell == nil) {
            cell = [self cellAtIndexPath:indexPath withIdentifier:cellIdentifier];
        }else{
            NSLog(@"[SYS]%@ reused", [cell reuseIdentifier] );
        }
        
        [self layoutCellUI:cell atIndexPath:indexPath];
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [[cell reuseIdentifier] isEqualToString:loadingCellIdentifier] == YES ) {
        if ( m_page < m_pageCount ) {
            m_page++;
            [self startAsyncWebData];
        }
    }
}
   
-(void)CreateEGORefreshTableHeaderView{
	// 下拉刷新的创建
	if (_refreshHeaderView == nil) {
		// 创建箭头视图
		EGORefreshTableHeaderView *egorefreshtableheaderview= [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - self.m_tableView.bounds.size.height, self.view.frame.size.width, self.m_tableView.bounds.size.height)];
		egorefreshtableheaderview.delegate = self;
		// 直接添加到表，位置为表的上方
		[self.m_tableView addSubview:egorefreshtableheaderview];
		_refreshHeaderView = egorefreshtableheaderview;
		[egorefreshtableheaderview release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];	
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	
	[self reAsyncWebData];
	
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.m_tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 表格滚动时自动调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	// 调用”箭头视图“的方法
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];	
}

// 结束拖拽时自动调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	// 调用”箭头视图“的方法
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading;
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date];
	
}	

#pragma mark select event

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRowAtIndexPath:indexPath];
}

-(void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell* cell = [m_tableView cellForRowAtIndexPath:indexPath];
    
    if ( [[cell reuseIdentifier] isEqualToString:loadingCellIdentifier]) {
        return;
    }
}

@end
