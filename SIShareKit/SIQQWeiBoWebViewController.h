//
//  SIQQWeiBoWebViewController.h
//  OpenSdkTest
//
//  Created by ChenYu Xiao on 12-7-17.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SIBaseDialogViewController.h"
#import "SIShareCommonHeader.h"

//#import "OpenSdkTestAppDelegate.h"

@class OpenApi;
@class OpenSdkOauth;

@protocol SISKTXWeiBoDialogDelegate <NSObject>
- (void)TXDialogDidLoginSuccess;
@end

@interface SIQQWeiBoWebViewController : SIBaseDialogViewController <UIWebViewDelegate>{
    UIWebView *_webView;
//    NSIndexPath *_lastIndexPath;
//    UILabel *_titleLabel;
    
//	NSArray* featureList;
//    NSMutableDictionary *_publishParams;
    
    OpenSdkOauth *openSdkOauth;
    OpenApi *_OpenApi;
    UIActivityIndicatorView *_indicatorView;
    id<SISKTXWeiBoDialogDelegate> delegate;
}

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) OpenSdkOauth *openSdkOauth;


@end
