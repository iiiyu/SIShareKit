//
//  OpenApi.h
//  OpenSdkTest
//
//  Created by aine sun on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OpenSdkRequest.h"
#import "OpenSdkOauth.h"
#import "OpenSdkResponse.h"

@class OpenApi;
//Define the protocol for the delegate
@protocol OpenApiDelegate <NSObject>

@optional

// 发送成功
- (void)sendSuccess:(OpenApi *)openApi;

// 发送失败
- (void)sendFaile:(OpenApi *)openApi;

// 调用接口失败
- (void)sendInterfaceFaile:(OpenApi *)openApi;

// 验证失败
- (void)authorizationFailedOrDidNotAuthorize:(OpenApi *)openApi;

// 调用成功
- (void)callFunctionSuccess:(OpenApi *)openApi withResult:(NSString *)resultString;

// 调用失败
- (void)callFunctionFailed:(OpenApi *)openApi;

// 获取用户信息时候调用接口失败
- (void)callTheInterfaceFailed:(OpenApi *)openApi;


@end

@interface OpenApi : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, OpenSdkOauthDelegate> {

    OpenSdkOauth *_OpenSdkOauth;
    OpenSdkRequest *_OpenSdkRequest;
    OpenSdkResponse *_OpenSdkResponse;
    
    NSMutableDictionary *_publishParams;
    NSString *_filePathName;
    uint16_t _retCode;
    
//    id<OpenApiDelegate> delegate;
}

@property (nonatomic) NSString *filePathName;
@property (nonatomic) uint16_t retCode;
@property (nonatomic, unsafe_unretained) id<OpenApiDelegate> delegate;
/*
 * 初始化
 */
- (id)initForApi:(NSString*)appKey appSecret:(NSString*)appSecret accessToken:(NSString*)accessToken accessSecret:(NSString*)accessSecret openid:(NSString *)openid oauthType:(uint16_t)oauthType;

/*
 * 发表微博
 */
- (void)publishWeibo:(NSString *)weiboContent jing:(NSString *)jing wei:(NSString *)wei format:(NSString *)format clientip:(NSString *)clientip syncflag:(NSString *)syncflag;

/*
 * 选择图片
 */
//- (void) insertImage:(id)delegate;

/*
 * 发表带图片微博
 */
- (void) publishWeiboWithImage:(NSString *)filePath weiboContent:(NSString *)weiboContent jing:(NSString *)jing wei:(NSString *)wei format:(NSString *)format clientip:(NSString *)clientip syncflag:(NSString *)syncflag;
/*
 * 用UIimage直接发微博
 */
- (void) publishWeiboWithUIImage:(UIImage *)image weiboContent:(NSString *)weiboContent jing:(NSString *)jing wei:(NSString *)wei format:(NSString *)format clientip:(NSString *)clientip syncflag:(NSString *)syncflag;

/*
 * 获取用户信息
 */
- (void) getUserInfo:(NSString *)format;

/*
 * 获取用户信息
 */
- (NSString *) newGetUserInfo:(NSString *)format;


/*
 * 拉取我收听的人列表
 */
- (void) getMyIdollist:(NSString *)format reqnum:(NSString *)reqnum startIndex:(NSString *)startIndex install:(NSString *)install pageCount:(NSInteger)pageCount;

/*
 * 拉取我的收听列表
 */
- (void) getMyFanslist:(NSString *)format reqnum:(NSString *)reqnum startIndex:(NSString *)startIndex mode:(NSString *)mode install:(NSString *)install;

@end
