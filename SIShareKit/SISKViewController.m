//
//  SISKViewController.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKViewController.h"

@interface SISKViewController ()

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
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [textView resignFirstResponder];
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
