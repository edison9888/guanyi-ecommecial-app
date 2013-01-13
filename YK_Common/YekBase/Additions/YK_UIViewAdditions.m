//
//  YK_UIViewAdditions.m
//  YD100
//
//  Created by wtfan on 11-11-27.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_UIViewAdditions.h"

@implementation UIView (YK_UIViewAdditions)

-(void)startLoading{
    UIActivityIndicatorView* l_actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    l_actView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    l_actView.tag = 534785438;
    [self addSubview:l_actView];
    [l_actView release];
    [l_actView startAnimating];
}

-(void)stopLoading{
    UIActivityIndicatorView* l_actView = (UIActivityIndicatorView*)[self viewWithTag:534785438];
    [l_actView stopAnimating];
    [l_actView removeFromSuperview];
}

@end
