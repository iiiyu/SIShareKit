//
//  OpenSdkOauth.m
//  OpenSdkTest
//
//  Created by aine sun on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OpenSdkOauth.h"
#import "SFHFKeychainUtils.h"
#import "SIShareCommonHeader.h"



/*
 * oauth2.0授权及调用api接口请求的base url
 */
static NSString *oauthRequestBaseURL = @"https://open.t.qq.com/cgi-bin/oauth2/";
static NSString *authPrefix = @"authorize";

/*
 * oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="

@implementation OpenSdkOauth

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;
@synthesize accessToken = _accessToken;
@synthesize accessSecret = _accessSecret;
@synthesize expireIn = _expireIn;
@synthesize openid = _openid;
@synthesize openkey = _openkey;
@synthesize oauthType = _oauthType;

#pragma -
#pragma mark init members

- (id)initAppKey:appKey appSecret:(NSString *)appSecret
{
	if ([super init]) 
	{
		[_appKey release];
        _appKey = [appKey copy];
		_appSecret = [appSecret copy];
        _redirectURI = [[NSString alloc] initWithString:[OpenSdkBase getRedirectUri]];
        if ([self isSessionValid]) {
            [self readAuthorizeDataFromKeychain];
        }
        
	}
	return self;
}

#pragma -
#pragma mark authorize in safari

- (BOOL)doSafariAuthorize:(BOOL)didOpenOtherApp
{
    BOOL didOpenAnotherApp = didOpenOtherApp;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appKey, @"client_id",
                                   @"token", @"response_type",
                                   _redirectURI, @"redirect_uri",
                                   @"2", @"wap",
                                   nil];
    
	NSLog(@"appkey is %@", _appKey);
	NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
    NSLog(@"authorizeurl is %@", authorizeURL);
	
	// 先尝试从safari打开网页
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) 
    {
        if(!didOpenAnotherApp)
        {
            NSString *appUrl = [OpenSdkBase generateURL:authorizeURL params:params httpMethod:@"GET"];
            NSLog(@"request url is %@", appUrl);
            didOpenAnotherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        }
    }
    return didOpenAnotherApp;
}

#pragma -
#pragma mark authorize in webView
- (void) doWebViewAuthorize:(UIWebView *)webView {
    
    _webView = webView;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appKey, @"client_id",
                                   @"token", @"response_type",
                                   @"2", @"wap",
                                   _redirectURI, @"redirect_uri",
                                   @"ios", @"appfrom",
                                   nil];
    NSLog(@"appkey is %@", _appKey);
    NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
    
    NSString *loadingURL = [[OpenSdkBase generateURL:authorizeURL params:params httpMethod:nil] retain];
    
    NSLog(@"request url is %@", loadingURL);
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadingURL]];
	
	[webView loadRequest:request];
}

#pragma -
#pragma mark viewController method

- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//__conn = new CIMCommonConnection() ;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	//delete __conn ;
}


- (void)dealloc {
    [super dealloc];
}

- (void) oauthDidSuccess:(NSString *)accessToken accessSecret:(NSString *)accessSecret openid:(NSString *)openid openkey:(NSString *)openkey expireIn:(NSString *)expireIn {
    self.accessToken = accessToken;
    self.accessSecret = accessSecret;
    self.openid = openid;
    self.openkey = openkey;
    self.expireIn = expireIn;
    NSLog(@"expireIn:%@", expireIn);
    //用户信息保存到本地
    [self saveAuthorizeDataToKeychain];
    
    [OpenSdkBase showMessageBox:@"登录成功！"];
}

- (void) oauthDidFail:(uint16_t)oauthType success:(BOOL)success netNotWork:(BOOL)netNotWork {
    NSLog(@"oauth type is %d", oauthType);
    if (oauthType == InAuth1 && success ) {
        [OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
    }
    else if(oauthType == InWebView) {
        if (success) {
            [OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
        }
        else {
            if (netNotWork) {
                [OpenSdkBase showMessageBox:@"无网络连接，请设置网络"];
            }
            else {
                [OpenSdkBase showMessageBox:@"授权失败，请认真检查appKey是否正确"];
            }
        }
    }
    else {
        NSLog(@"oauth type is %@", oauthType);
    }
}

- (void) refuseOauth:(NSURL *)url {
    NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    start = [[url absoluteString] rangeOfString:@"code="];
    if (start.location != NSNotFound) {
        NSString *code = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"code="];
        NSString *type = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"checkType="];
        NSLog(@"code is %@, type is %@", code, type);
        if ([code isEqualToString:@"101"] && [type isEqualToString:@"error"]) {
            
            NSLog(@"refuse to authorize");
            [OpenSdkBase showMessageBox:@"用户拒绝webView授权"];
        }
    }
}


- (void)saveAuthorizeDataToKeychain
{
//    self.accessToken = accessToken;
//    self.accessSecret = accessSecret;
//    self.openid = openid;
//    self.openkey = openkey;
//    self.expireIn = expireIn;
    
    
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kTXKeychainServiceNameSuffix];
    [SFHFKeychainUtils storeUsername:kWBKeychainUserID andPassword:self.openid forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kWBKeychainAccessToken andPassword:self.accessToken forServiceName:serviceName updateExisting:YES error:nil];
	[SFHFKeychainUtils storeUsername:kWBKeychainExpireTime andPassword:self.expireIn forServiceName:serviceName updateExisting:YES error:nil];
}

- (void)readAuthorizeDataFromKeychain
{
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kTXKeychainServiceNameSuffix];
    self.openid = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
    self.accessToken = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
    self.expireIn = [SFHFKeychainUtils getPasswordForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil];
}

- (void)deleteAuthorizeDataInKeychain
{
//    self.userID = nil;
//    self.accessToken = nil;
//    self.expireTime = 0;
    self.openid = nil;
    self.accessToken = nil;
    self.expireIn = nil;
    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kTXKeychainServiceNameSuffix];
    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil];
//    
//    NSString *serviceName = [[self urlSchemeString] stringByAppendingString:kWBKeychainServiceNameSuffix];
//    [SFHFKeychainUtils deleteItemForUsername:kWBKeychainUserID andServiceName:serviceName error:nil];
//	[SFHFKeychainUtils deleteItemForUsername:kWBKeychainAccessToken andServiceName:serviceName error:nil];
//	[SFHFKeychainUtils deleteItemForUsername:kWBKeychainExpireTime andServiceName:serviceName error:nil];
}


- (NSString *)urlSchemeString
{
    return [NSString stringWithFormat:@"%@%@", kTXURLSchemePrefix, self.appKey];
}

-(BOOL)isSessionValid
{
//    BOOL result = NO;
    [self readAuthorizeDataFromKeychain];
    NSDate *expirationDate =nil;
    if (self.expireIn != nil) {
        int expVal = [self.expireIn intValue];
        if (expVal == 0) {
            expirationDate = [NSDate distantFuture];
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
        } 
    } 
    return (self.openid != nil && self.accessToken != nil && self.expireIn != nil && NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    
//    return result;
}

- (void)logOut
{
    _accessToken = nil;
    _expireIn = nil;
    _openid = nil;
    [self deleteAuthorizeDataInKeychain];
}


@end
