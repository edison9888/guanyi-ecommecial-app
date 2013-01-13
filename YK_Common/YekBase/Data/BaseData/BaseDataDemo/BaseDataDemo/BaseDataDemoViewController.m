//
//  BaseDataDemoViewController.m
//  BaseDataDemo
//
//  Created by wtfan on 11-11-10.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "BaseDataDemoViewController.h"

#import "HomeData.h"
#import "ProductData.h"

#import "GDataXMLNode.h"

@implementation BaseDataDemoViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* l_str_xml = @" <home result=\"success\">  \
    <topiclist type=\"A\"> \
    <topic type=\"buy\" topicid=\"aaaa\" searchKey=\"001\" title=\"限时限量 5折秒杀\" sub=\"手机用户专享活动 每日更新中\" image=\"iphone/i4/miaosha/shouye_m1.jpg\">  \
    <description><![CDATA[啊啊啊啊]]></description> \
    </topic> \
    <topic type=\"buy\" topicid=\"bbbb\" searchKey=\"002\" title=\"限时限量 5折秒杀\" sub=\"手机用户专享活动 每日更新中\" image=\"iphone/i4/miaosha/shouye_m2.jpg\"> \
    <description><![CDATA[哇哈哈哈]]></description> \
    </topic> \
    <description><![CDATA[带格式的CDATA]]></description> \
    </topiclist> \
    </home>";
    
    NSError* l_error;
    GDataXMLElement* l_xmlEle = [[GDataXMLElement alloc] initWithXMLString:l_str_xml error:&l_error];
    
    for (HomeData* l_homeData in [HomeData easyParseFromGDataXMLElement:l_xmlEle]) {
        NSLog(@"%@", l_homeData);
        for (Topic* l_t in [l_homeData m_mutArray_topic]) {
            NSLog(@"%@", l_t);
        }
    }
    
    [l_xmlEle release];
    
    NSLog(@"===============================================================");

    l_str_xml = @"<product> \
    <product_id>00054166</product_id> \
    <product_name>【Epin】亿品秋冬新款女装韩版淑女长袖修身连衣裙（黑色）<a>dsadsadsasasas</a></product_name> \
    <list_price>179.0</list_price> \
    <shelf_price>79.0</shelf_price> \
    <image_s_path> http://s.yaodian100.com/PImg/0005/00054166/00054166_m75.jpg</image_s_path> \
    <myTest>aaaaaaaaaaaaa</myTest>\
	</product>";
    
    l_xmlEle = [[GDataXMLElement alloc] initWithXMLString:l_str_xml error:&l_error];
    
    ProductData* l_productData = [[ProductData alloc] init];
    [l_productData parseStringValueFromGDataXmlElement:l_xmlEle];
    NSLog(@"%@", l_productData);
    [l_productData release];
    NSLog(@"===============================================================");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
