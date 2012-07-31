//
//  SISKQQWeiBoDialogView.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-20.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKBaseDialogView.h"
#import "SIShareCommonHeader.h"
#import "OpenSdkOauth.h"
#import "OpenApi.h"

@class SISKQQWeiBoDialogView;

@protocol SISKQQWeiBoDialogViewDelegate <NSObject>

@optional

// 登录成功
- (void)oauthDidSuccess:(SISKQQWeiBoDialogView *)dialogView;

// 登录失败
- (void)oauthDidFailed:(SISKQQWeiBoDialogView *)dialogView;

@end

@interface SISKQQWeiBoDialogView : SISKBaseDialogView <UIWebViewDelegate>
//{
//    id<SISKQQWeiBoDialogViewDelegate> delegate;
//}
//
@property (unsafe_unretained, nonatomic) id<SISKQQWeiBoDialogViewDelegate> delegate;

@end
