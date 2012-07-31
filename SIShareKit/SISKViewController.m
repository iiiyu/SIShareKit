//
//  SISKViewController.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKViewController.h"
//#import "OpenApi.h"
//#import "OpenSdkOauth.h"
#import "SISKTXWeiboEngine.h"
//#import "SISKBaseDialogView.h"
//#import "SISKQQWeiBoDialogView.h"
#import "SISKQQSendView.h"


@interface SISKViewController ()<SISKTXWeiboEngineDelegate, SISKQQSendViewDelegate>

@end

@implementation SISKViewController
@synthesize textViewMessage = _textViewMessage;
@synthesize imageViewSend   = _imageViewSend;

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textViewMessage.delegate = self;
}

-(void)viewDidUnload
{
    [self setTextViewMessage: nil];
    [self setImageViewSend: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITextViewDelegate
-(BOOL)textView: (UITextView *) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString *) text
{
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
        return(NO);
    }
    return(YES);
}

#pragma mark - tx button action
-(IBAction)txLoginAction: (id) sender
{
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    engine.delegate = self;

    if (![engine isSessionValid]) {
        [engine showLogin];
    }
}

-(IBAction)txLogoutAction: (id) sender
{
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    engine.delegate = self;

    if ([engine isSessionValid]) {
        [engine logout];
    }
}

-(IBAction)txSendAction: (id) sender
{
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    engine.delegate = self;
    
    if ([engine isSessionValid]) {
        SISKQQSendView *sendview = [[SISKQQSendView alloc] initWithText:_textViewMessage.text image:_imageViewSend.image];
        sendview.qqSendDelegate = self;
        [sendview show:YES];
//        [engine sendPublishWeiboWithUIImage:_imageViewSend.image weiboContent:_textViewMessage.text];
    }else{
        [engine showLogin];
    }
    
}

-(IBAction)testViewAction: (id) sender
{
}

-(IBAction)mmSendAction: (id) sender
{
}


#pragma mark - SISKTXWeiboEngineDelegate
// 登录成功
-(void)oauthDidSuccess: (SISKTXWeiboEngine *) engine
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登录"
                                                        message: @"登录成功"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];

    [alertView show];
}

// 登录失败
-(void)oauthDidFailed: (SISKTXWeiboEngine *) engine withErrorNumber: (NSInteger) errorNumber
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登录"
                                                        message: @"登录失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 拒绝授权
-(void)userRefuseAuthorize: (SISKTXWeiboEngine *) engine
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登录"
                                                        message: @"拒绝授权"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 发送成功
-(void)sendSuccess: (SISKTXWeiboEngine *) engine;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"发送成功"
                                                        message: @"发送成功"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 发送失败
-(void)sendFailed: (SISKTXWeiboEngine *) engine;
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"发送失败"
                                                        message: @"发送失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 调用接口失败
-(void)sendInterfaceFaile: (SISKTXWeiboEngine *) engine
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"调用接口失败"
                                                        message: @"调用接口失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 验证失败
-(void)authorizationFailedOrDidNotAuthorize: (SISKTXWeiboEngine *) engine
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"验证失败"
                                                        message: @"验证失败"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

// 调用成功
-(void)callFunctionSuccess: (SISKTXWeiboEngine *) engine withResult: (NSString *) resultString
{
    
}

// 调用失败
-(void)callFunctionFailed: (SISKTXWeiboEngine *) engine
{
    
}

// 获取用户信息时候调用接口失败
-(void)callTheInterfaceFailed: (SISKTXWeiboEngine *) engine
{
    
}

// 登出完成
-(void)logoutDidSuccess: (SISKTXWeiboEngine *) engine
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"登出完成"
                                                        message: @"登出完成"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}


#pragma mark - SISKQQSendViewDelegate
- (void)buttonActionWillSendWeibo:(SISKQQSendView *)sendView
                        withImage:(UIImage *)image
                       andMessage:(NSString *)message
{
        SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    engine.delegate = self;

    [engine sendPublishWeiboWithUIImage:image weiboContent:message];
    [sendView hide:YES];
}

@end
