//
//  SCNSearchViewController.m
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNSearchViewController.h"
#import "Go2PageUtility.h"
#import "SCNSearchKeywordsTableCell.h"
#import "YKStringUtility.h"
#import "SCNDataInterface.h"
#import "SCNStatusUtility.h"
#import "YK_DateUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNSearchData.h"
#import "YKButtonUtility.h"
#import "YKStatBehaviorInterface.h"
#import "GY_Collections.h"

@implementation SCNSearchViewController

#define KEYWORDS_TABLEVIEW_ROW_HEIGHT 48
#define KEYWORDS_TABLEVIEW_HEADER_HEIGHT 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置搜索栏标题
    self.navigationItem.title=@"搜索";
	
	self.pathPath = @"/search";
    //关闭搜索框的自动大写功能
    [self.m_searchBar_keywordSearch setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    //关闭搜索的自动更正功能
    [self.m_searchBar_keywordSearch setAutocorrectionType:UITextAutocorrectionTypeNo];
    //隐藏searchBar的scope
    [self.m_searchBar_keywordSearch setShowsScopeBar:NO];
    //初始化热门关键字
    if (!self.m_array_keywords) {
        self.m_array_keywords=[@[] mutableCopy];
    }
    
    /*
     初始化热门关键字搜索关联相关键词
     */
    if (!self.m_array_filterKeywords) {
        self.m_array_filterKeywords=[@[] mutableCopy];
    }
    
    //查询显示控制器初始化
    UISearchDisplayController *tempDisplay=[[UISearchDisplayController alloc] initWithSearchBar:self.m_searchBar_keywordSearch contentsController:self];
    [self.m_searchBar_keywordSearch setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.m_searchDisplay_filterController=tempDisplay;
    //设置委托
    [self.m_searchDisplay_filterController setDelegate:self];
    [self.m_searchDisplay_filterController setSearchResultsDataSource:self];
	self.m_searchDisplay_filterController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.m_searchBar_keywordSearch resignFirstResponder];
    //请求服务器获得热门关键字
    if (!_isRequestSuccess) 
	{
        [self requestSearchViewJSONData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //取消搜索框的第一响应
    [self.m_searchBar_keywordSearch resignFirstResponder];
    
    if (m_number_requestID!=nil) {
        NSLog(@"取消最近的一次请求");
        [YKHttpAPIHelper cancelRequestByID:m_number_requestID];
    }
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.m_tableView_keywords=nil;
    self.m_searchBar_keywordSearch=nil;
    self.m_searchDisplay_filterController=nil;
}



#pragma -
#pragma mark 跳转到搜索结果页面
-(void)goToSearchResultView:(id)sender{
    
    UIButton *currentBtn=(UIButton*)sender;
    SCNSearchKeywordsTableCell *currentCell=(SCNSearchKeywordsTableCell*)[[currentBtn superview] superview];
    
    if (currentBtn==currentCell.m_button_left) {
		[self behaviorSearch:currentCell.m_label_left.text searchSource:YKSearch_Hot];
        [Go2PageUtility go2ProductListViewController:self withKeyword:currentCell.m_label_left.text withCategoryId:@"" withIsSearch:YES withCategoryName:@"" withBrandId:@"" withTypeId:@"" withType:@""];
    }else if(currentBtn==currentCell.m_button_right){
		[self behaviorSearch:currentCell.m_label_right.text searchSource:YKSearch_Hot];
        [Go2PageUtility go2ProductListViewController:self withKeyword:currentCell.m_label_right.text withCategoryId:@"" withIsSearch:YES withCategoryName:@"" withBrandId:@"" withTypeId:@"" withType:@""];
    }
    
    
}

#pragma -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{// called when text starts editing
    //显示取消按钮
    [self.m_searchBar_keywordSearch setShowsCancelButton:YES animated:YES];
    
    for(id cc in [searchBar subviews])
    {
        //更改searchBar的取消按钮样式
        if([cc isKindOfClass:[UIButton class]])
        {
            //这里可以设置Button的样式
            UIButton *btn = (UIButton *)cc;
			btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        //更改键盘的search按钮
        if([cc isKindOfClass:[UITextField class]])
        {
            //这里可以设置Button的样式
            UITextField *text = (UITextField *)cc;
			text.returnKeyType=UIReturnKeySearch;
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    //取消SearchBar的第一响应
    [self.m_searchBar_keywordSearch resignFirstResponder];
    //隐藏取消按钮
    [self.m_searchBar_keywordSearch setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[self behaviorSearch:self.searchDisplayController.searchBar.text searchSource:YKSearch_UserInput];
    [Go2PageUtility go2ProductListViewController:self withKeyword:self.searchDisplayController.searchBar.text withCategoryId:nil withIsSearch:YES withCategoryName:nil withBrandId:nil withTypeId:nil withType:nil];
}

#pragma mark -
#pragma mark Content Filtering
/**
 查询过滤器，在查询条中输入字母即可自动调用(每输入一个字母就调用一次)，参数为查询内容和范围标识匹配
 */

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSLog(@" search keyword is %@" , searchText);
    
	//清空查询结果表
//	[self.m_array_filterKeywords removeAllObjects]; // First clear the filtered array. if using arc this will be exception in ios6 need reinit it
	self.m_array_filterKeywords = [@[] mutableCopy];
    
	if([self.m_array_filterKeywords count] == 0 && searchText.length > 0)
	{
		[self.m_array_filterKeywords addObject:self.searchDisplayController.searchBar.text];
    }
	
	NSString *keyword=[YKStringUtility strOrEmpty:searchText];
    if (!_isRequesting &&  keyword.length > 0) {
        [self requestSearchViewAssociateJSONData:keyword];
    }
    
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
//searchString系统传过来的查询条的内容
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

//展开查询控制器开始查询，并设置查询器委托
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	//设置查询结果表的delegate委托，针对查询结果表让didSelectRowAtIndexPath方法执行
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}
//搜索查询控制器结束查询，并修改表的坐标隐藏查询栏
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{	
	//[self.searchDisplayController.searchResultsTableView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma -
#pragma mark TableViewDelegate & TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //如果系统传过来的表对象是“查询结果表”
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		//返回查询(过滤)表对应的“过滤数组”的长度
        return [self.m_array_filterKeywords count];
    }
	else
	{
		//返回源数据的数组的长度
		return m_int_rowsOfTable;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.m_tableView_keywords) {
        return KEYWORDS_TABLEVIEW_HEADER_HEIGHT;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, KEYWORDS_TABLEVIEW_HEADER_HEIGHT)];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:@"    热门搜索关键词列表"];
    return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row=indexPath.row;
    NSString* keywordData=nil;
    
    if (tableView==self.m_searchDisplay_filterController.searchResultsTableView) {//联想表
        static NSString *kCellID = @"cellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
            [YKButtonUtility setCommonCellBg:cell];
        }
        keywordData=[self.m_array_filterKeywords objectAtIndex:row];
		cell.textLabel.text=[YKStringUtility strOrEmpty:keywordData];
        [cell.textLabel setTextColor:[UIColor blackColor]];//
		cell.textLabel.highlightedTextColor = [UIColor blackColor];
		
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
    }else{
        static NSString *CellIdentifier = @"SCNSearchKeywordTableCell";
        
        SCNSearchKeywordsTableCell *cell = (SCNSearchKeywordsTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"SCNSearchKeywordsTableCell" owner:self options:nil];
            cell=[views objectAtIndex:0];
            [YKButtonUtility setCommonCellBg:cell];
        }
        
        /**
         热门关键字列表数据分布
         0  1
         2  3
         4  5
         6  7
         ...
         ...
         */
        int leftKeyIndex=row*2;
        int rightKeyIndex=row*2+1;
        
        if (leftKeyIndex<[self.m_array_keywords count]) {//左边关键字列表
            keywordData=[self.m_array_keywords objectAtIndex:leftKeyIndex];
            cell.m_label_left.text=keywordData;
            cell.m_label_right.text=@"";
            [cell.m_imageView_left setImage:[DataWorld getImageWithFile:@"com_arrow.png"]];
            [cell.m_button_left addTarget:self action:@selector(goToSearchResultView:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (rightKeyIndex<[self.m_array_keywords count]) {//右边关键字列表
            keywordData=[self.m_array_keywords objectAtIndex:rightKeyIndex];
            cell.m_label_right.text=keywordData;
            [cell.m_imageView_right setImage:[DataWorld getImageWithFile:@"com_arrow.png"]];
            [cell.m_button_right addTarget:self action:@selector(goToSearchResultView:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *currentCell=[tableView cellForRowAtIndexPath:indexPath];
        [self behaviorSearch:currentCell.textLabel.text searchSource:YKSearch_History];
        [Go2PageUtility go2ProductListViewController:self withKeyword:currentCell.textLabel.text withCategoryId:@"" withIsSearch:YES withCategoryName:@"" withBrandId:@"" withTypeId:@"" withType:@""];
    }
}
#pragma -
#pragma mark 请求热门关键字数据

-(void)requestSearchViewJSONData{
    if (_isRequesting) {
        return;
    }
    _isRequesting=YES;
    [self startLoading];
    /*
     act            对应接口的方法     N	getHotKeyword
     api_version	API版本          N	1.0
     t              客户端时间戳      N	12087021
     weblogid                       N	123123
     ac             数据验证签名      N	POST提交的参数按照字母序升序组合+token，进行MD5加密
     */
    NSDictionary* extraParam = @{@"method": MMUSE_METHOD_GET_HOTKEYWORD};
    m_number_requestID=[YKHttpAPIHelper startLoadJSON:MMUSE_URL
                                      extraParams:extraParam
                                           object:self
                                         onAction:@selector(onRequestSearchViewJSONDataResponse:)];
}


-(void)onRequestSearchViewJSONDataResponse:(id)json_obj
{
    _isRequesting = NO;
    [self stopLoading];
    //    if (![SCNStatusUtility isRequestSuccessJSON:json_obj])
    //	{
    //        NSLog(@"json 解析错误"); NSLog(@"网络连接失败");
    //        return;
    //    }
    
    GY_Collection_Hot_Keywords* coll_hot_keywords = [[GY_Collection_Hot_Keywords alloc]initWithJSON:json_obj];
    self.m_array_keywords = coll_hot_keywords.arr_hot_keywords;
    
    if([self.m_array_keywords count]>0 ){
        m_int_rowsOfTable=([self.m_array_keywords count]+1)/2;
        //            CGFloat height=m_int_rowsOfTable*KEYWORDS_TABLEVIEW_ROW_HEIGHT+KEYWORDS_TABLEVIEW_HEADER_HEIGHT;
        //            //改变表的高度
        //            [self.m_tableView_keywords setFrame:CGRectMake(self.m_tableView_keywords.frame.origin.x, self.m_tableView_keywords.frame.origin.y, 320,height)];
        [self.m_tableView_keywords reloadData];

    }else{
        
    }
}
// todo 搞定request success的问题
//-(void)onRequestSearchViewJSONDataResponse:(GDataXMLDocument*)xmlDoc{
//    _isRequesting = NO;
//    [self stopLoading];
//    if([SCNStatusUtility isRequestSuccess:xmlDoc]) 
//    {
//        _isRequestSuccess = YES;
//                    
//        }else{
//            
//        }
//    }
//    else
//    {
//        _isRequestSuccess = NO;
//    }
//}
#pragma -
#pragma mark 请求搜索关联关键字数据

-(void)requestSearchViewAssociateJSONData:(NSString*)keyword{
    if (_isRequesting) {
        return;
    }
    _isRequesting=YES;
    [self startLoading];

    
    NSDictionary* extraParam = @{@"method": MMUSE_METHOD_GET_ASSOCIATE,
                                @"keyword": keyword};
    NSLog(@"keyword is %@",keyword);
    [YKHttpAPIHelper startLoadJSON:MMUSE_URL extraParams:extraParam object:self onAction:@selector(onRequestSearchViewAssociateJSONDataResponse:)];
}
-(void)onRequestSearchViewAssociateJSONDataResponse:(id)json_obj{
    _isRequesting = NO;
    [self stopLoading];
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) 
	{
        _isRequestSuccess = YES;
		
        self.m_array_filterKeywords = [@[] mutableCopy];
//        [self.m_array_filterKeywords removeAllObjects];
        
        GY_Collection_Filter_Keywords* _data = [[GY_Collection_Filter_Keywords alloc] initWithJSON:json_obj];
        self.m_array_filterKeywords = _data.arr_filter_keywords;
        
        NSLog(@"关联关键字%@",self.m_array_filterKeywords);
        
		if([self.m_array_filterKeywords count] == 0 && self.searchDisplayController.searchBar.text.length > 0)
		{
			[self.m_array_filterKeywords addObject:self.searchDisplayController.searchBar.text];
		} 

		
        [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(self.searchDisplayController.searchResultsTableView.frame.origin.x, self.searchDisplayController.searchResultsTableView.frame.origin.y,320,460-36-40)];
        [self.searchDisplayController.searchResultsTableView reloadData];
		
    }
    else
    {

		if([self.m_array_filterKeywords count] == 0 && self.searchDisplayController.searchBar.text.length > 0)
		{
			[self.m_array_filterKeywords addObject:self.searchDisplayController.searchBar.text];
		}
		
        _isRequestSuccess = NO;
    }
//	if ([self.m_array_filterKeywords count] == 0)
//	{
//		UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
//		for (UIView *subview in tableView1.subviews)
//		{
//			if ([subview isKindOfClass:[UILabel class]])
//			{
//				UILabel *lbl = (UILabel*)subview; // sv changed to subview.
//				lbl.text = @"无相应关联词";
//				break;
//			}
//		}
//	}

}

//搜索条件|条件来源id
//（例：衬衫|0）-------（0用户输入、1历史记录、2热词推荐）
-(void)behaviorSearch:(NSString*)_keyword searchSource:(NSInteger)_searchSource{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|%d",_keyword,_searchSource];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SEARCH param:_param];
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}
@end
