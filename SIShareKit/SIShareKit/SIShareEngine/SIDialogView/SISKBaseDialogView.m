//
//  SISKBaseDialogView.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-19.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKBaseDialogView.h"

#define kPadding    10

@interface SISKBaseDialogView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SISKBaseDialogView

@synthesize containerView = _containerView;
@synthesize backgroundView = _backgroundView;
@synthesize closeButton    = _closeButton;
@synthesize webView        = _webView;
@synthesize activityIndicator = _activityIndicator;

- (id)init
{
	self = [super initWithFrame: [UIScreen mainScreen].bounds];
	if (self) {
		_containerView = [[UIView alloc] initWithFrame:self.frame];
	    _containerView.clipsToBounds = YES;
		[self addSubview:_containerView];
		
		_backgroundView = [[UIView alloc] initWithFrame:self.frame];
		_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_backgroundView.backgroundColor  = [UIColor blackColor];
		_backgroundView.alpha            = 0.5f;
		_backgroundView.layer.cornerRadius = 10.0;
		[_containerView addSubview: _backgroundView];
		
		_closeButton       = [UIButton buttonWithType: UIButtonTypeCustom];
		[_closeButton setImage: [UIImage imageNamed: @"close.png"] forState: UIControlStateNormal];
		[_closeButton setImage: [UIImage imageNamed: @"close_selected.png"] forState: UIControlStateHighlighted];
		[_closeButton addTarget: self action: @selector(hide) forControlEvents: UIControlEventTouchUpInside];
		[_containerView addSubview: _closeButton];
		
		_webView = [[UIWebView alloc] initWithFrame:self.frame];
		[_containerView addSubview: _webView];
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicator.hidesWhenStopped = YES;
		[_containerView addSubview:_activityIndicator];
		
		[self sizeToFitOrientation: YES];
	}
	return self;
}


#pragma mark - Obeservers

-(void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(deviceOrientationDidChange:)
												 name: UIDeviceOrientationDidChangeNotification object: nil];
}

-(void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: UIDeviceOrientationDidChangeNotification object: nil];
}


#pragma mark - show and hide

-(void)show
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	
	if (!window)
	{
		window = [[UIApplication sharedApplication].windows objectAtIndex: 0];
	}
	[window addSubview: self];
	
	_webView.delegate = self;
	[self addObservers];
	[self sizeToFitOrientation: YES];
	
	_containerView.alpha = 0;
	_containerView.transform = CGAffineTransformMakeScale(0.2, 0.2);
	[UIView animateWithDuration:0.2
					 animations:^{
						 _containerView.alpha = 0.8;
						 _containerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:0.15
										  animations:^{
											  _containerView.alpha = 0.9;
											  _containerView.transform = CGAffineTransformMakeScale(0.92, 0.92);
										  }
										  completion:^(BOOL finished) {
											  [UIView animateWithDuration:0.2
															   animations:^{
																   _containerView.alpha = 1;
																   _containerView.transform = CGAffineTransformIdentity;
															   }];
										  }];
					 }];
	
}

-(void)hide
{
	_webView.delegate = nil;
	[UIView animateWithDuration: 0.25
						  delay: 0
						options: UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _containerView.transform = CGAffineTransformMakeScale(0.2, 0.2);
						 _containerView.alpha = 0;
					 }
					 completion:^(BOOL finished){
						 [self removeObservers];
						 [self removeFromSuperview];
					 }];
}

#pragma mark - 自动选择旋转
- (void)sizeToFitOrientation: (BOOL) transform
{
	if (transform) {
		self.transform = CGAffineTransformIdentity;
	}
	
	CGRect  frame  = [UIScreen mainScreen].applicationFrame;
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if ([UIApplication sharedApplication].isStatusBarHidden) {
			self.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
		} else {
			self.frame = CGRectMake(0, 0, frame.size.height + 20.0, frame.size.width - 20.0);
		}
	} else {
		self.frame = frame;
	}
	
	_containerView.frame = CGRectMake(kPadding, kPadding, frame.size.width - kPadding * 2, frame.size.height - kPadding * 2);
	_webView.frame = CGRectMake(kPadding, kPadding + 20, frame.size.width - kPadding * 4, frame.size.height - kPadding * 4 - 20);
	_closeButton.frame = CGRectMake(_containerView.frame.size.width - 30, 0, 30, 30);
	_activityIndicator.center = self.center;
	
	if (transform) {
		self.transform = [self transformForOrientation];
	}
}

// 选择动画
-(CGAffineTransform)transformForOrientation
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	
	if (orientation == UIInterfaceOrientationLandscapeLeft)
	{
		return(CGAffineTransformMakeRotation(M_PI * 1.5));
	}
	else if (orientation == UIInterfaceOrientationLandscapeRight)
	{
		return(CGAffineTransformMakeRotation(M_PI / 2));
	}
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		return(CGAffineTransformMakeRotation(-M_PI));
	}
	else
	{
		return(CGAffineTransformIdentity);
	}
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

-(void)deviceOrientationDidChange: (id) object
{
	[self sizeToFitOrientation: YES];
}

-(void)loadRequestWithURL: (NSURL *) url
{
	NSURLRequest *request = [NSURLRequest requestWithURL: url
											 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval: 60.0];
	
	[_webView loadRequest: request];
}

#pragma mark - UIWebViewDelegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
	[_activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
	[_activityIndicator stopAnimating];
}


@end
