//
//  SCNHomeData.m
//  SCN
//
//  Created by yuanli on 11-9-29.
//  Copyright 2011 Yek.me. All rights reserved.
//

#import "SCNHomeData.h"

@implementation SCNHomeData

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{

    [super dealloc];
}
@end

/*...........................................................*/
@implementation coverflowHomeData

@synthesize mid,mtype,mimage;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
    [mid release];      
    mid = nil;
    [mtype release];    
    mtype = nil;
    [mimage release];   
    mimage  = nil;
    [super dealloc];
}
@end


/*...........................................................*/
@implementation activityHomeData

@synthesize mtitle,moff,mproductCode,mimage;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
    [mtitle release];
    mtitle = nil;
    [moff release]; 
    moff   = nil;
    [mproductCode release]; 
    mproductCode = nil;
    [mimage release]; 
    mimage = nil;
    [super dealloc];
}
@end


/*...........................................................*/
@implementation topicHomeData

@synthesize mtitle,mproductCode,mtype,micon;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)dealloc
{
    [mtitle release]; 
    mtitle = nil;
    [mproductCode release];   
    mproductCode   = nil;
    [mtype release];
    mtype = nil;
    [micon release]; 
    micon = nil;
    [super dealloc];
}
@end