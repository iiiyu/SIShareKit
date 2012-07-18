//
//  SIQQWeiBoWebViewController.h
//  OpenSdkTest
//
//  Created by ChenYu Xiao on 12-7-17.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SIBaseDialogViewController.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"
//#import "OpenSdkTestAppDelegate.h"

@interface SIQQWeiBoWebViewController : SIBaseDialogViewController {
    UIWebView *_webView;
    NSIndexPath *_lastIndexPath;
    UILabel *_titleLabel;
    
	NSArray* featureList;
    NSMutableDictionary *_publishParams;
    
    OpenSdkOauth *_OpenSdkOauth;
    OpenApi *_OpenApi;
    UIActivityIndicatorView *_indicatorView;
}

@property ( nonatomic)UIWebView *webView;
@property (nonatomic)UIActivityIndicatorView *indicatorView;

@end
