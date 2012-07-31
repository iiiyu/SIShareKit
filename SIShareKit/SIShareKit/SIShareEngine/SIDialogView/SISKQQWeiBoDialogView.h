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

@interface SISKQQWeiBoDialogView : SISKBaseDialogView <UIWebViewDelegate>

- (void)showLoginWebView;

@end
