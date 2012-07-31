//
//  SISKTXWeiboEngine.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenApi.h"
//#import "SISKQQWeiBoDialogView.h"
#import "OpenSdkOauth.h"
#import "SISKQQWeiBoDialogView.h"
@class OpenApi;

@class SISKTXWeiboEngine;
@protocol SISKTXWeiboEngineDelegate <NSObject>

@optional
// 登录成功
- (void)oauthDidSuccess:(SISKTXWeiboEngine *)engine;

// 登录失败
- (void)oauthDidFailed:(SISKTXWeiboEngine *)engine withErrorNumber:(NSInteger)errorNumber;

// 拒绝授权
- (void)userRefuseAuthorize:(SISKTXWeiboEngine *)engine;

// 发送成功
- (void)sendSuccess:(SISKTXWeiboEngine *)engine;

// 发送失败
- (void)sendFailed:(SISKTXWeiboEngine *)engine;

// 调用接口失败
- (void)sendInterfaceFaile:(SISKTXWeiboEngine *)engine;

// 验证失败
- (void)authorizationFailedOrDidNotAuthorize:(SISKTXWeiboEngine *)engine;

// 调用成功
- (void)callFunctionSuccess:(SISKTXWeiboEngine *)engine withResult:(NSString *)resultString;

// 调用失败
- (void)callFunctionFailed:(SISKTXWeiboEngine *)engine;

// 获取用户信息时候调用接口失败
- (void)callTheInterfaceFailed:(SISKTXWeiboEngine *)engine;

// 登出完成
- (void)logoutDidSuccess:(SISKTXWeiboEngine *)engine;



@end


@interface SISKTXWeiboEngine : NSObject<OpenSdkOauthDelegate,OpenApiDelegate, SISKQQWeiBoDialogViewDelegate>
{
//    id<SISKTXWeiboEngineDelegate> delegate;
}
@property (unsafe_unretained, nonatomic) id<SISKTXWeiboEngineDelegate> delegate;



@property (strong, nonatomic) OpenApi *openApi;

#pragma mark - Init
/*
 * 获取静态、共享的SISKTXWeiboEngine实例对象。SISKTXWeiboEngine类的单例方法。
 * @return 返回共享的SISKTXWeiboEngine单例对象。
 */
+ (SISKTXWeiboEngine *) sharedSISKTXWeiboEngine;

#pragma mark - Public Methods

/*
 * 判断用户登录后的当前会话生命周期是否有效。
 * @return 当前session有效,返回YES,否则, NO.
 */
-(BOOL)isSessionValid;

/**
 * 授权页面方式获取授权——弹层页面
 * @param permissions 需要开通的权限字符串数组。
 * @param delegate 实现RenrenDelegate协议的类型对象。
 */
- (void)showLogin;


/**
 * 用户登出时调用本方法。
 * @param delegate 实现RenrenDelegate协议的类型对象。
 */
//- (void)logout:(id<RenrenDelegate>)delegate;
- (void)logout;

/*
 *用filepath发微博
 */
- (void)sendPublishWeiBoWithImage:(NSString *)filePath weiboContent:(NSString *)weiboContent;

/*
 *用UIImage发微博
 */
- (void)sendPublishWeiboWithUIImage:(UIImage *)image weiboContent:(NSString *)weiboContent;

/*
 *获得用户名
 */
- (NSString *)getUserName;

@end
