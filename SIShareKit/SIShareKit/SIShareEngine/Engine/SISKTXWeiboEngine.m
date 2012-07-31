//
//  SISKTXWeiboEngine.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKTXWeiboEngine.h"
#import "OpenApi.h"
#import "OpenSdkOauth.h"
#import "SIShareCommonHeader.h"
#import "SISKQQWeiBoDialogView.h"
//#import "SISKTestViewController.h"

@interface SISKTXWeiboEngine()


@property (strong, nonatomic) OpenSdkOauth *openSdkOauth;

@end

@implementation SISKTXWeiboEngine
@synthesize openApi = _openApi;
@synthesize openSdkOauth = _openSdkOauth;
//@synthesize delegate = _delegate;

+ (SISKTXWeiboEngine *)sharedSISKTXWeiboEngine
{
    static SISKTXWeiboEngine *engine = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{ engine = [[self alloc] init];});
    return engine;
}

- (id)init
{
    self = [super init];
    if (self) {
        _openSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
        _openSdkOauth.oauthType = oauthMode;
        _openApi = [[OpenApi alloc] initForApi:_openSdkOauth.appKey appSecret:_openSdkOauth.appSecret accessToken:_openSdkOauth.accessToken accessSecret:_openSdkOauth.accessSecret openid:_openSdkOauth.openid oauthType:_openSdkOauth.oauthType];
//        _openApi.delegate = delegate;
//        delegate = _openApi.delegate;
    }
    return self;
}


- (BOOL)isSessionValid
{
    return [_openSdkOauth isSessionValid];
}

- (void)showLogin
{
//    SIQQWeiBoWebViewController *viewController = [[SIQQWeiBoWebViewController alloc] init];
//    viewController.openSdkOauth = _openSdkOauth;
////    [viewController show];
////    SISKTestViewController *viewController = [[SISKTestViewController alloc] init];
//    [viewController show];
    SISKQQWeiBoDialogView *view = [[SISKQQWeiBoDialogView alloc] init];
    [view showLoginWebView];



}

- (void)sendPublishWeiBoWithImage:(NSString *)filePath weiboContent:(NSString *)weiboContent
{
//    [_openApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"112.123456" wei:@"33.111252" format:@"xml" clientip:@"CLIENTIP" syncflag:@"1"];  
        [_openApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"" wei:@"" format:@"xml" clientip:@"CLIENTIP" syncflag:@"1"];  
//    NSLog(@"1");
}

//    [_OpenApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"112.123456" wei:@"33.111252" format:@"xml" clientip:@"CLIENTIP" syncflag:@"1"];  


- (void)logout
{
    if ([self isSessionValid]) {
        [_openSdkOauth logOut];
    }
}





@end
