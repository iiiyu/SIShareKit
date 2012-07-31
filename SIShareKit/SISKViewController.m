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

@interface SISKViewController () <OpenApiDelegate>

@end

@implementation SISKViewController
@synthesize textViewMessage = _textViewMessage;
@synthesize imageViewSend = _imageViewSend;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _textViewMessage.delegate = self;
    
}

- (void)viewDidUnload
{
    [self setTextViewMessage:nil];
    [self setImageViewSend:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - tx button action 
- (IBAction)txLoginAction:(id)sender {
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    if (![engine isSessionValid]) {
        [engine showLogin];
    }
    
}

- (IBAction)txLogoutAction:(id)sender {
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    if ([engine isSessionValid]) {
        [engine logout];
    }
}

- (IBAction)txSendAction:(id)sender {
    SISKTXWeiboEngine *engine = [SISKTXWeiboEngine sharedSISKTXWeiboEngine];
    engine.openApi.delegate = self;
    if (![engine isSessionValid]) {
        [engine showLogin];
    }else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mm" ofType:@"jpg"];
        [engine sendPublishWeiBoWithImage:filePath weiboContent:_textViewMessage.text];
    }
}

- (IBAction)testViewAction:(id)sender {

}

- (IBAction)mmSendAction:(id)sender {

}


#pragma mark - OpenApidelegate
-(void)sendSuccess:(OpenApi *)openApi
{
    NSLog(@"success");
}

-(void)sendFaile:(OpenApi *)openApi
{
    NSLog(@"faile");
}

- (void)sendInterfaceFaile:(OpenApi *)openApi
{
    NSLog(@"interface faile");
}

@end
