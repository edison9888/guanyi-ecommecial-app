//
//  YK_OkOrderInfoStatistic.m
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_OkOrderInfoStatistic.h"

#import "YK_StatisticEngine.h"
#import "YK_NSStringAdditions.h"
#import "YKHttpEngine.h"

@implementation YK_OkOrderInfoStatistic
@synthesize msessionid;
@synthesize morderid;
@synthesize mordermessage;
@synthesize musername;
@synthesize muserid;
@synthesize mfullname;
@synthesize mcellphone;
@synthesize mprovince;
@synthesize mcity;
@synthesize mcounty;
@synthesize maddress;
@synthesize mamount;
@synthesize mordertime;
@synthesize mitemdata;
@synthesize mtime;

@synthesize mresult;
@synthesize mdesc;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"msessionid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"morderid", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mordermessage", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"musername", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"muserid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mfullname", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcellphone", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mprovince", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcity", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcounty", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"maddress", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mamount", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mordertime", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mitemdata", @"@\"NSString\"")
				   )

+(id)initWithOrderInfoDict:(NSDictionary*)orderInfoDict{
    assert([orderInfoDict objectForKey:@"orderid"]!=nil);
    assert([orderInfoDict objectForKey:@"ordermessage"]!=nil);
    assert([orderInfoDict objectForKey:@"username"]!=nil);
    assert([orderInfoDict objectForKey:@"userid"]!=nil);
    assert([orderInfoDict objectForKey:@"fullname"]!=nil);
    assert([orderInfoDict objectForKey:@"cellphone"]!=nil);
    assert([orderInfoDict objectForKey:@"province"]!=nil);
    assert([orderInfoDict objectForKey:@"city"]!=nil);
    assert([orderInfoDict objectForKey:@"county"]!=nil);
    assert([orderInfoDict objectForKey:@"address"]!=nil);
    assert([orderInfoDict objectForKey:@"amount"]!=nil);
    assert([orderInfoDict objectForKey:@"ordertime"]!=nil);
    assert([orderInfoDict objectForKey:@"itemdata"]!=nil);
    YK_OkOrderInfoStatistic* _orderInfoStatistic = [[YK_OkOrderInfoStatistic alloc] init];
    if (self!=nil) {
        _orderInfoStatistic.morderid = [orderInfoDict objectForKey:@"orderid"];
        _orderInfoStatistic.mordermessage = [orderInfoDict objectForKey:@"ordermessage"];
        _orderInfoStatistic.musername = [orderInfoDict objectForKey:@"username"];
        _orderInfoStatistic.muserid = [orderInfoDict objectForKey:@"userid"];
        _orderInfoStatistic.mfullname = [orderInfoDict objectForKey:@"fullname"];
        _orderInfoStatistic.mcellphone = [orderInfoDict objectForKey:@"cellphone"];
        _orderInfoStatistic.mprovince = [orderInfoDict objectForKey:@"province"];
        _orderInfoStatistic.mcity = [orderInfoDict objectForKey:@"city"];
        _orderInfoStatistic.mcounty = [orderInfoDict objectForKey:@"county"];
        _orderInfoStatistic.maddress = [orderInfoDict objectForKey:@"address"];
        _orderInfoStatistic.mamount = [orderInfoDict objectForKey:@"amount"];
        _orderInfoStatistic.mordertime = [orderInfoDict objectForKey:@"ordertime"];
        _orderInfoStatistic.mitemdata = [orderInfoDict objectForKey:@"itemdata"];
    }
    return _orderInfoStatistic;
}


- (NSString*)description
{
	return [NSString stringWithFormat:@"<OkorderStatistic.%d> msessionid:%@, morderid:%@, musername:%@, mfullname:%@, mcellphone:%@, mprovince:%@, mcity:%@, mcounty:%@, maddress:%@, mamount:%@, mordertime:%@, mitemdata:%@", 
			[self pk], msessionid, morderid, musername, mfullname, mcellphone, mprovince, mcity, mcounty, maddress, mamount, mordertime, mitemdata];
}

-(void)postOrderInfoStatistic{
    /**
      1.优先使用我方服务器的时间。
     */
    @synchronized(self){
        YK_TimeStatistic* _timeStatistic = [[YK_TimeStatistic alloc] init];
        _timeStatistic.delegate = self;
        [_timeStatistic postTimeRequest];
    }
}

/**
 上传已确认订单
 */
-(void)onRequestTimeStatisticFinished:(NSString*)timeStr{
    self.mtime = [NSString stringWithFormat:@"%@", timeStr];
    // ordertime策略优先级：1. 合作方服务器时间；2. 我方服务器时间；3. 本地时间
    if ([mordertime length]==0) { // 合作方时间为空，既不传
        self.mordertime = [NSString stringWithFormat:@"%@", timeStr];
    }
	if ([self.msessionid length] == 0) { // sessionid为空
        YK_ClientInfoStatistic* _clientInfoStatistic = [[YK_ClientInfoStatistic alloc] init];
        _clientInfoStatistic.muserid = self.muserid;
        _clientInfoStatistic.musername = self.musername;
        _clientInfoStatistic.delegate = self;
        [_clientInfoStatistic postClientinfo];
    }else{
        [self onRequestClientInfoStatisticFinished:self.msessionid];
    }
}

-(void)onRequestClientInfoStatisticFinished:(NSString*)_sessionid{
    self.msessionid = [NSString stringWithFormat:@"%@", _sessionid];
    /**
     productcode        产品编号，新项目时必须向服务器组申请备案                                vancl，详见附录4.1
     sessionid          3.2接口返回的                                                       128d6aaced36a08f3893d1eaf953d425
     orderid            订单号(如果没有向客户服务器提交成功，则填写空字符)                        100010
     ordermessage       订单消息，用于说明订单提交情况，在订单号返回为空的时候必须填写客户服务器返回的失败信息（失败时此字段不能为空），有订单号的时候必须填写“订单提交成功 ”                                             库存不足，请修改后重新提交订单
     username           下单的用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，
     一定要和订单的账户一致，如果没有登录则留空
     
     fullname           收货人全名                                                           张三
     cellphone          收货人联系电话（手机号码或者固定电话号码）                                15903863890
     province           收货人所在省份，格式例如：安徽、上海、北京，                               江苏
     后面的“省”字和直辖市的“市”字就不要填写了                          
     city               收货人所在城市，格式例如：南京、沈阳、上海、北京，                          南京
     后面的“市”字就不要填写了
     
     county             收货人所在区县、例如：浦东、朝阳、崇明，后面的“县”字和“区”字就不要填写了      鼓楼
     address            详细的收货地址                                                        高科中路22号412室
     amount             订单总金额（需要实际支付的金额，但不包括运费）                             240
     time               提交时间的时间戳， 从3.1接口中获取                                      1310969879
     ordertime          实际下单时间的时间戳，优先使用电商接口中返回的下单时间戳       1310969001
     itemdata           订单商品信息，XML格式，具体见样例
     参数说明：
     code：商品编号
     name：商品全名
     price：商品价格
     quantity：购买的数量
     color：商品颜色(在例如书籍等商品不需要填写颜色请留空)
     size：商品尺码(在例如书籍等商品不需要填写尺码请留空)，另外注意XML各属性一定要格式化
     <list>
     <item code=”YM10001” name=”白色短裤” price=”100” quantity=”2” color=”白色” size=”XL”/>
     <item code=”PU132325” name=”法国红酒” price=”40” quantity=”1” color=”” size=”” />
     </list>
     ver              通讯协议版本，区别于客户端版本和操作系统版本，此参数不能随意变更，如有变更代表着通讯协议的更新，请与平台部陈大磊联系以了解更多细节。                            1. 2
     sign               数据验证签名,32位md5                       md5(sessionid+orderid+ time)    4eb096d9eafa0f460ff759e7de05e90e
     */
    NSString* now = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    
	NSString* url = [[YK_StatisticEngine sharedStatisticEngine] m_str_url_orderInfo];
	
    NSString* productcode = [[YK_StatisticEngine sharedStatisticEngine] productcode];
    NSString* sessionid = [NSString stringWithFormat:@"%@", msessionid==nil?@"":msessionid];
    NSString* orderid = [NSString stringWithFormat:@"%@", morderid==nil?@"":morderid];
    NSString* ordermessage = [NSString stringWithFormat:@"%@", mordermessage==nil?@"":mordermessage];
    NSString* username = [NSString stringWithFormat:@"%@", musername==nil?@"":musername];
    NSString* fullname = [NSString stringWithFormat:@"%@", mfullname==nil?@"":mfullname];
    NSString* cellphone = [NSString stringWithFormat:@"%@", mcellphone==nil?@"":mcellphone];
    NSString* province = [NSString stringWithFormat:@"%@", mprovince==nil?@"":mprovince];
    NSString* city = [NSString stringWithFormat:@"%@", mcity==nil?@"":mcity];
    NSString* county = [NSString stringWithFormat:@"%@", mcounty==nil?@"":mcounty];
    NSString* address = [NSString stringWithFormat:@"%@", maddress==nil?@"":maddress];
    NSString* amount = [NSString stringWithFormat:@"%@", mamount==nil?@"":mamount];
    NSString* time = [NSString stringWithFormat:@"%@", mtime==nil?@"":mtime];
    NSString* ordertime = [NSString stringWithFormat:@"%@", mordertime==nil?@"":mordertime];
    ordertime = ([ordertime length]==0?now:ordertime);
    NSString* itemdata = [NSString stringWithFormat:@"%@", mitemdata==nil?@"":mitemdata];
    NSString* ver = [[YK_StatisticEngine sharedStatisticEngine] ver];
    NSString* sign = [[NSString stringWithFormat:@"%@%@%@", sessionid, orderid, time] md5Hash];
    
	NSDictionary* extraParam = @{@"productcode": productcode,
                                @"sessionid": sessionid,
                                @"ordermessage": ordermessage,
                                @"orderid": orderid,
                                @"username": username,
                                @"fullname": fullname,
                                @"cellphone": cellphone,
                                @"province": province,
                                @"city": city,
                                @"county": county,
                                @"address": address,
                                @"amount": amount,
                                @"time": time,
                                @"ordertime": ordertime,
                                @"itemdata": itemdata,
                                @"ver": ver,
                                @"sign": sign};
	
    [[YK_StatisticEngine sharedHttpEngine] startDefaultAsynchronousRequest:url
                                                             postParams:extraParam 
                                                                 object:self
                                                       onFinishedAction:@selector(onPostOkorderFinished:)
                                                         onFailedAction:@selector(onPostOkorderFailed:)];
}

/**
    请求成功。
    返回数据样例:
    会话失败：
    <home result="sessionerror" desc=”会话不存在，请重新发起会话”/>
    其他失败情况：
    <home result="failure" desc=”你的操作系统不在备案区域内”/>
    成功：
    < home result="success"  desc=”提交成功”>
 */
-(void)onPostOkorderFinished:(ASIHTTPRequest*)request{
    NSString *responseString = [request responseString];;
    NSError *error;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
    
    if (error==nil) {
        [self parseFromGDataXMLElement:[xmlDoc rootElement]];
        /**
            xmlDoc解析成功
         */
        if ([@"success" isEqualToString:self.mresult]) {
            /**
             请求成功时：
             1. 删除数据库中该订单信息。
             */
            [self deleteObject];
        }else if([@"sessionerror" isEqualToString:self.mresult]){
            /**
             sessionid失效时：
             1. 保存一份sessionid为空的订单信息至数据库中。
             2. 删除数据库中该订单信息。
             */
            YK_OkOrderInfoStatistic* _orderInfoStatistic = [[YK_OkOrderInfoStatistic alloc] init];
            _orderInfoStatistic.msessionid = @"";
            _orderInfoStatistic.morderid = self.morderid;
            _orderInfoStatistic.mordermessage = self.mordermessage;
            _orderInfoStatistic.musername = self.musername;
            _orderInfoStatistic.muserid = self.muserid;
            _orderInfoStatistic.mfullname = self.mfullname;
            _orderInfoStatistic.mcellphone = self.mcellphone;
            _orderInfoStatistic.mprovince = self.mprovince;
            _orderInfoStatistic.mcity = self.mcity;
            _orderInfoStatistic.mcounty = self.mcounty;
            _orderInfoStatistic.maddress = self.maddress;
            _orderInfoStatistic.mamount = self.mamount;
            _orderInfoStatistic.mordertime = self.mordertime;
            _orderInfoStatistic.mitemdata = self.mitemdata;
            [_orderInfoStatistic save];
            
            [self deleteObject];
        }else{
            /**
             请求失败时：
             1. 拷贝并保存该订单信息至数据库中。
             2. 删除数据库中该订单信息。
             */
            YK_OkOrderInfoStatistic* _orderInfoStatistic = [[YK_OkOrderInfoStatistic alloc] init];
            _orderInfoStatistic.msessionid = self.msessionid;
            _orderInfoStatistic.morderid = self.morderid;
            _orderInfoStatistic.mordermessage = self.mordermessage;
            _orderInfoStatistic.musername = self.musername;
            _orderInfoStatistic.muserid = self.muserid;
            _orderInfoStatistic.mfullname = self.mfullname;
            _orderInfoStatistic.mcellphone = self.mcellphone;
            _orderInfoStatistic.mprovince = self.mprovince;
            _orderInfoStatistic.mcity = self.mcity;
            _orderInfoStatistic.mcounty = self.mcounty;
            _orderInfoStatistic.maddress = self.maddress;
            _orderInfoStatistic.mamount = self.mamount;
            _orderInfoStatistic.mordertime = self.mordertime;
            _orderInfoStatistic.mitemdata = self.mitemdata;
            [_orderInfoStatistic save];
            
            [self deleteObject];
        }
    }else{
        /**
            xmlDoc解析失败，不做任何动作
         */
    }
    
}

/**
    请求失败, 不做任何动作
 */
-(void)onPostOkorderFailed:(ASIHTTPRequest*)request{
}

@end
