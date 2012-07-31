//
//  SISKTXWeiboEngine.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenApi.h"

@class OpenApi;

//@class SISKTXWeiboEngine;
//@protocol SISKTXWeiboEngineDelegate <OpenApiDelegate>
//
////- (void)sendSuccess:(SISKTXWeiboEngine *)engine;
//
//@end


@interface SISKTXWeiboEngine : NSObject
//{
//    id<SISKTXWeiboEngineDelegate> delegate;
//}
//@property (strong, nonatomic) id<SISKTXWeiboEngineDelegate> delegate;
//
//

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

- (void)sendPublishWeiBoWithImage:(NSString *)filePath weiboContent:(NSString *)weiboContent;

@end
