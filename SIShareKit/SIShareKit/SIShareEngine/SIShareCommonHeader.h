//
//  SIShareCommonHeader.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#ifndef SIShareKit_SIShareCommonHeader_h
#define SIShareKit_SIShareCommonHeader_h

//

enum {
    SISKDialogOperateSuccess,
    SISKDialogOperateFailure,
    SISKDialogOperateCancel
};
typedef NSUInteger SISKDialogOperateType;


#define kTXAppKey @"801205233"
#define kTXAPPSecret @"5607611faafa29d17c6a46ec7429b43f"
/*
 * Todo：请正确填写您的应用网址，否则将导致TX微博授权失败
 */
#define redirect_uri @"https://github.com/iiiyu/SIShareKit"

/*
 * Todo: 请填写您需要的登录授权方式，目前支持webview和浏览器两种方式，分别为InWebView和InSafari，其中浏览器方式需要手动获取授权码，不建议使用
 */
#define oauthMode InWebView

#define kTXURLSchemePrefix @"TX_"

#define kWBKeychainServiceNameSuffix    @"_WeiBoServiceName"
#define kWBKeychainUserID               @"WeiBoUserID"
#define kWBKeychainAccessToken          @"WeiBoAccessToken"
#define kWBKeychainExpireTime           @"WeiBoExpireTime"

#define kTXKeychainServiceNameSuffix @"_TXWeiBoServiceName"
#define kTXKeychainOpenID @"TXWeiBoOpenID"
#define kTXKeychainAccessToken @"TXWeiBoAccessToken"
#define kTXKeychainExpireTime @"TXWeiBoExpireTime"

#ifndef kTXAppKey
#error
#endif

#ifndef kTXAPPSecret
#error
#endif

#ifndef redirect_uri
#error
#endif

#ifndef oauthMode
#error
#endif




#endif
