//
//  SISKBaseDialogView.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-19.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SISKBaseDialogView : UIView
{
    UIView *backgroundView;
    UIButton *closeButton;
    UIWebView *webView;
}

@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

//+ (SISKBaseDialogView *) shareSISKBaseDialogView;

- (void)showInView;

- (void)hide;

- (void)loadRequestWithURL:(NSURL *)url;

@end
