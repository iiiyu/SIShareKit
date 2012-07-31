//
//  SISKQQWeiBoDialogView.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-20.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKQQWeiBoDialogView.h"

@interface SISKQQWeiBoDialogView()

@property (strong, nonatomic)OpenSdkOauth *openSdkOauth;

@end

/*
 * oauth2.0授权及调用api接口请求的base url
 */
static NSString *oauthRequestBaseURL = @"https://open.t.qq.com/cgi-bin/oauth2/";
static NSString *authPrefix = @"authorize";

/*
 * oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expire_in="

@implementation SISKQQWeiBoDialogView
@synthesize openSdkOauth = _openSdkOauth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

//- (void)showInView{
//    self.webView.delegate = self;
//    [super showInView];
//    
//}

- (void)showLoginWebView
{
    self.webView.delegate = self;
    uint16_t authorizeType = oauthMode; 
    
    _openSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _openSdkOauth.oauthType = authorizeType;
    

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [OpenSdkBase getAppKey], @"client_id",
                                   @"token", @"response_type",
                                   @"2", @"wap",
                                   [[NSString alloc] initWithString:[OpenSdkBase getRedirectUri]], @"redirect_uri",
                                   @"ios", @"appfrom",
                                   nil];
    NSLog(@"appkey is %@", [OpenSdkBase getAppKey]);
    NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
    
    NSString *loadingURL = [OpenSdkBase generateURL:authorizeURL params:params httpMethod:nil] ;
    
    NSLog(@"request url is %@", loadingURL);
    
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadingURL]];
	
	[self.webView loadRequest:request];
    [self showInView];
}

- (void)hide
{
    [super hide];
    [self.webView setDelegate:nil];
    _openSdkOauth = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - UIWebViewDelegate Method
/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
////    [_indicatorView stopAnimating];
//    
    NSURL* url = request.URL;
//    
    NSLog(@"response url is %@", url);
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    //如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
        NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
        
		NSDate *expirationDate =nil;
		if (_openSdkOauth.expireIn != nil) {
			int expVal = [_openSdkOauth.expireIn intValue];
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
        
        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_openSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_openSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
//            if ([delegate respondsToSelector:@selector(TXDialogDidLoginSuccess)]) {
//                [delegate TXDialogDidLoginSuccess];
//                //                [delegate TXDidLogin:self];
//            }
        }
//        self.webView.delegate = nil;
//        [self.webView setHidden:YES];
        //        [_titleLabel setHidden:YES];
        
        [self hide];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_openSdkOauth refuseOauth:url];
        }
	}
    return YES;
}
//
/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
//    [_indicatorView stopAnimating];
    NSString *url = self.webView.request.URL.absoluteString;
    NSLog(@"web view finish load URL %@", url);
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
//    
//    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
//        [_openSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
//        [_webView removeFromSuperview];
//        //        [_titleLabel removeFromSuperview];
//	}
}

@end
