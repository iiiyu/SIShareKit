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
#import "SISKQQSendView.h"
#import "NSString+SBJSON.h"

@interface SISKTXWeiboEngine ()

@property (strong, nonatomic) OpenSdkOauth *openSdkOauth;

@end

@implementation SISKTXWeiboEngine
@synthesize openApi      = _openApi;
@synthesize openSdkOauth = _openSdkOauth;
@synthesize delegate;

+(SISKTXWeiboEngine *)sharedSISKTXWeiboEngine
{
    static SISKTXWeiboEngine *engine = nil;
    static dispatch_once_t   onceToken;

    dispatch_once(&onceToken, ^{ engine = [[self alloc] init];
                  });
    return(engine);
}

-(id)init
{
    self = [super init];

    if (self) {
        _openSdkOauth           = [[OpenSdkOauth alloc] initAppKey: [OpenSdkBase getAppKey] appSecret: [OpenSdkBase getAppSecret]];
        _openSdkOauth.oauthType = oauthMode;
        _openSdkOauth.delegate  = self;

        _openApi = [[OpenApi alloc] initForApi : _openSdkOauth.appKey
                                     appSecret : _openSdkOauth.appSecret
                                   accessToken : _openSdkOauth.accessToken
                                  accessSecret : _openSdkOauth.accessSecret
                                        openid : _openSdkOauth.openid
                                     oauthType : _openSdkOauth.oauthType];
        _openApi.delegate = self;
    }

    return(self);
}

-(BOOL)isSessionValid
{
    return([_openSdkOauth isSessionValid]);
}

-(void)showLogin
{
    SISKQQWeiBoDialogView *view = [[SISKQQWeiBoDialogView alloc] init];

    view.delegate = self;
    [view show];
}

-(void)sendPublishWeiBoWithImage: (NSString *) filePath weiboContent: (NSString *) weiboContent
{
    [_openApi publishWeiboWithImage : filePath
                       weiboContent : weiboContent
                               jing : @"" wei: @""
                             format : @"xml"
                           clientip : @"CLIENTIP"
                           syncflag : @"1"];
}

-(void)sendPublishWeiboWithUIImage: (UIImage *) image weiboContent: (NSString *) weiboContent
{
    [_openApi publishWeiboWithUIImage : image
                         weiboContent : weiboContent
                                 jing : @""
                                  wei : @""
                               format : @"xml"
                             clientip : @"CLIENTIP"
                             syncflag : @"1"];
}

-(void)logout
{
    if ([self isSessionValid]) {
        [_openSdkOauth logOut];

        if ([[self delegate] respondsToSelector: @selector(logoutDidSuccess:)]) {
            [delegate logoutDidSuccess: self];
        }
    }
}

#pragma mark - OpenSdkOauthDelegate
-(void)authenticationOauthFailed: (OpenSdkOauth *) openSdkOauth withErrorNumber: (NSInteger) errorNumber
{
    if ([[self delegate] respondsToSelector: @selector(oauthDidFailed:withErrorNumber:)]) {
        [delegate oauthDidFailed: self withErrorNumber: errorNumber];
    }
}

// 登录成功
-(void)authenticationOauthSuccess: (OpenSdkOauth *) openSdkOauth
{
    if ([[self delegate] respondsToSelector: @selector(oauthDidSuccess:)]) {
        [delegate oauthDidSuccess: self];
    }
}

// 拒绝授权
-(void)userRefuseAuthorize: (OpenSdkOauth *) openSdkOauth
{
    if ([[self delegate] respondsToSelector: @selector(userRefuseAuthorize:)]) {
        [delegate userRefuseAuthorize: self];
    }
}

#pragma mark - OpenApiDelegate

// 发送成功
-(void)sendSuccess: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(sendSuccess:)]) {
        [delegate sendSuccess: self];
    }
}

// 发送失败
-(void)sendFaile: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(sendFaile:)]) {
        [delegate sendFailed: self];
    }
}

// 调用接口失败
-(void)sendInterfaceFaile: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(sendInterfaceFaile:)]) {
        [delegate sendInterfaceFaile: self];
    }
}

// 验证失败
-(void)authorizationFailedOrDidNotAuthorize: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(authorizationFailedOrDidNotAuthorize:)]) {
        [delegate authorizationFailedOrDidNotAuthorize: self];
    }

    [self logout];
}

// 调用成功
-(void)callFunctionSuccess: (OpenApi *) openApi withResult: (NSString *) resultString
{
    if ([[self delegate] respondsToSelector: @selector(callFunctionSuccess:withResult:)]) {
        [delegate callFunctionSuccess: self withResult: resultString];
    }
}

// 调用失败
-(void)callFunctionFailed: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(callFunctionFailed:)]) {
        [delegate callFunctionFailed: self];
    }
}

// 获取用户信息时候调用接口失败
-(void)callTheInterfaceFailed: (OpenApi *) openApi
{
    if ([[self delegate] respondsToSelector: @selector(callTheInterfaceFailed:)]) {
        [delegate callTheInterfaceFailed: self];
    }
}

// // 发送成功
// - (void)callFunctionSuccess:(SISKTXWeiboEngine *)engine withResult:(NSString *)resultString
// {
//    if ([[self delegate] respondsToSelector:@selector(callFunctionSuccess:withResult:)]) {
//        [delegate callFunctionSuccess:self withResult:resultString];
//    }
// }
//
// // 发送失败
// - (void)callFunctionFailed:(SISKTXWeiboEngine *)engine
// {
//    if ([[self delegate] respondsToSelector:@selector(callFunctionFailed:)]) {
//        [delegate callFunctionFailed:self];
//    }
// }
//
// // 调用接口失败
// - (void)callTheInterfaceFailed:(SISKTXWeiboEngine *)engine
// {
//    if ([[self delegate] respondsToSelector:@selector(callTheInterfaceFailed:)]) {
//        [delegate callTheInterfaceFailed:self];
//    }
// }
//
// // 发送成功
// - (void)sendSuccess:(SISKTXWeiboEngine *)engine
// {
//    if ([[self delegate] respondsToSelector:@selector(sendSuccess:)]) {
//        [delegate sendSuccess:self];
//    }
// }
//
// // 验证失败
// - (void)authorizationFailedOrDidNotAuthorize:(SISKTXWeiboEngine *)engine
// {
// }

-(NSString *)getUserName
{
    NSString     *resultStr = [_openApi newGetUserInfo: @"json"];
    NSDictionary *userInfo  = [resultStr JSONValue];
    NSString     *result    = [[NSString alloc] initWithString: (NSString *)[[userInfo objectForKey: @"data"] objectForKey: @"nick"]];

    return(result);
}

#pragma mark -  SISKQQWeiBoDialogViewDelegate

// 登录成功
-(void)oauthDidSuccess: (SISKQQWeiBoDialogView *) dialogView
{
    [_openSdkOauth readAuthorizeDataFromKeychain];

    if ([[self delegate] respondsToSelector: @selector(oauthDidSuccess:)]) {
        [delegate oauthDidSuccess: self];
    }
    [dialogView hide];
}

// 登录失败
-(void)oauthDidFailed: (SISKQQWeiBoDialogView *) dialogView
{
}

@end