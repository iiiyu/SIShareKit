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
#import "SIQQWeiBoWebViewController.h"
#import "SISKTestViewController.h"

@interface SISKTXWeiboEngine()

@property (strong, nonatomic) OpenApi *openApi;
@property (strong, nonatomic) OpenSdkOauth *openSdkOauth;

@end

@implementation SISKTXWeiboEngine
@synthesize openApi = _openApi;
@synthesize openSdkOauth = _openSdkOauth;

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
//        _OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey appSecret:_OpenSdkOauth.appSecret accessToken:_OpenSdkOauth.accessToken accessSecret:_OpenSdkOauth.accessSecret openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
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
//    [viewController show];
    SISKTestViewController *viewController = [[SISKTestViewController alloc] init];
    [viewController show];


}

- (void)logout
{
    if ([self isSessionValid]) {
        [_openSdkOauth logOut];
    }
}




@end
