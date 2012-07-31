//
//  SISKBaseDialogView.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-19.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SISKBaseDialogView : UIView <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

- (void)show;
- (void)hide;

- (void)loadRequestWithURL:(NSURL *)url;

@end
