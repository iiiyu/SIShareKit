//
//  SISKBaseDialogView.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-19.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKBaseDialogView.h"

#define kPadding 10

@interface SISKBaseDialogView()
@property (nonatomic, assign) UIInterfaceOrientation orientation;

//- (void)memoryWarning:(NSNotification*)notification;

@end

@implementation SISKBaseDialogView
@synthesize backgroundView = _backgroundView;
@synthesize orientation = _orientation;
@synthesize closeButton = _closeButton;
@synthesize webView = _webView;



//+ (SISKBaseDialogView *)shareSISKBaseDialogView
//{
//    static SISKBaseDialogView *baseDialogView = nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{ baseDialogView = [[self alloc] init];});
//    return baseDialogView;
//}
//
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        self = [[SISKBaseDialogView alloc] initWithFrame:CGRectZero];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //设置新的view有多大 设置圆角
        
        [self setFrame:CGRectMake(10, 20, frame.size.width - 20, frame.size.height - 40)];
        self.backgroundColor = [UIColor clearColor];
        [self.layer setCornerRadius:10.0];
        [self.layer setMasksToBounds:YES];
        self.clipsToBounds = YES;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0, 
                                                                   self.frame.size.width, 
                                                                   self.frame.size.height)];
        
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5f;
        [self addSubview:_backgroundView];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.frame.size.width - (kPadding + 25), 0,35, 35);
        [_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"close_selected.png"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 
                                                               35, 
                                                               _backgroundView.frame.size.width - 20,
                                                               _backgroundView.frame.size.height - 35)];
        [self addSubview:_webView];

//        NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com.cn"];
//        NSURLRequest *request =[NSURLRequest requestWithURL:url
//                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                            timeoutInterval:60.0];
//        [_webView loadRequest:request];
        
        [self sizeToFitOrientation:YES];
    }
    return self;
}


#pragma mark - Obeservers

- (void)addObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark - show and hide

- (void)showInView
{
    [self sizeToFitOrientation:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    
    // 弹出动画
    self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.5, 0.5, 1);
    self.alpha = 0;
    [UIView animateWithDuration:0.10
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut//| UIViewAnimationCurveEaseOut
                     animations:^{	
                         self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 1.0, 1.0, 1.0);
                         self.alpha = 1;
                     }
                     completion:NULL];
    [self addObservers];
}

- (void)hide
{
    // 缩小动画
    [UIView animateWithDuration:0.15
						  delay:0
						options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
					 animations:^{	
						 self.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, 0, 0), 0.8, 0.8, 1.0);
						 self.alpha = 0;
					 }
					 completion:^(BOOL finished){ 
                         if(self.alpha == 0) {
                             [self removeObservers];
                             [self removeFromSuperview];
                         }
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - 自动选择旋转
- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width / 2),
                                 frame.origin.y + ceil(frame.size.height / 2));
    
    CGFloat width = frame.size.width - kPadding * 2;
    CGFloat height = frame.size.height - kPadding * 2;
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // 细节调节每一个view的位置
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
        _webView.frame = CGRectMake(kPadding, kPadding + 20, height - 20, width - 35);
        _closeButton.frame = CGRectMake(self.frame.size.width - (kPadding + 25), 0, 35, 35);
    }else if(UIInterfaceOrientationPortraitUpsideDown == _orientation){
//        self.frame = CGRectMake(kPadding, kPadding, width, height);
//        _webView.frame = CGRectMake(kPadding, kPadding + 20, width - 20, height - 35);
//        _closeButton.frame = CGRectMake(self.frame.size.height - (kPadding + 25), 0, 35, 35);
        //180度旋转时候设置
    }else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
        _webView.frame = CGRectMake(kPadding, kPadding + 20, width - 20, height - 35);
        _closeButton.frame = CGRectMake(self.frame.size.width - (kPadding + 25), 0, 35, 35);
    }
    
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

// 选择动画
- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI * 1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI / 2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
    [self sizeToFitOrientation:YES];
//	UIInterfaceOrientation orientation = [self currentOrientation];
//	if ([self shouldRotateToOrientation:orientation])
//    {
//        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//        
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationDuration:duration];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//		[self sizeToFitOrientation:orientation];
//		[UIView commitAnimations];
//	}
}

- (void)loadRequestWithURL:(NSURL *)url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [_webView loadRequest:request];
}

//- (void)showInView:(UIView*)view 
//{
//    BOOL addingToWindow = NO;
//    
//    if (!view) {
//        NSArray *keyWindows = [UIApplication sharedApplication].windows;
//        UIWindow *keyWindow = [keyWindows lastObject];
//        addingToWindow = YES;
//        
//        if([keyWindow respondsToSelector:@selector(rootViewController)])
//            view = keyWindow.rootViewController.view;
//        
//        if(view == nil)
//            view = keyWindow;
//    }
//}

//#pragma mark - MemoryWarning
//
//- (void)memoryWarning:(NSNotification *)notification {
//	
//    if (self.superview == nil) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        self = nil;
//    }
//}



@end
