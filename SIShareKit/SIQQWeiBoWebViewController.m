//
//  SIQQWeiBoWebViewController.m
//  OpenSdkTest
//
//  Created by ChenYu Xiao on 12-7-17.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SIQQWeiBoWebViewController.h"

/*
 * Todo: 请填写您需要的登录授权方式，目前支持webview和浏览器两种方式，分别为InWebView和InSafari，其中浏览器方式需要手动获取授权码，不建议使用
 */
#define oauthMode InWebView

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expire_in="

@interface SIQQWeiBoWebViewController () <UIWebViewDelegate>
- (void) testLoginWithMicroblogAccount;
@end

@implementation SIQQWeiBoWebViewController
@synthesize webView = _webView;
@synthesize indicatorView = _indicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:[self fitOrientationFrame]];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.hidesWhenStopped = YES;
    _indicatorView.center = _webView.center;
    [self.view addSubview:_indicatorView];
    
    [self testLoginWithMicroblogAccount];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate Method
/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL* url = request.URL;
    
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
		if (_OpenSdkOauth.expireIn != nil) {
			int expVal = [_OpenSdkOauth.expireIn intValue];
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
            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
        }
        _webView.delegate = nil;
        [_webView setHidden:YES];
        [_titleLabel setHidden:YES];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
    return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url = _webView.request.URL.absoluteString;
    NSLog(@"web view finish load URL %@", url);
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
    
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
        [_webView removeFromSuperview];
        [_titleLabel removeFromSuperview];
	}
}


/*
 * 采用两种不同方式进行登录授权,支持webview和浏览器两种方式
 */
- (void) testLoginWithMicroblogAccount {
    
    uint16_t authorizeType = oauthMode; 
    
    _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _OpenSdkOauth.oauthType = authorizeType;
    
    BOOL didOpenOtherApp = NO;
    switch (authorizeType) {
        case InSafari:  //浏览器方式登录授权，不建议使用
        {
            didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
            break;
        }
        case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
        {
            if(!didOpenOtherApp){
                if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
                    NSLog(@"client_id is null");
                    [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
                }
                else
                {
//                    [self webViewShow];
                }
                
                [_OpenSdkOauth doWebViewAuthorize:_webView];
                
                break;
            }
        }
        default:
            break;
    }
}

@end
