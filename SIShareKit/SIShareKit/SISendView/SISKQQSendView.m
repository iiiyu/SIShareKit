//
//  SISKQQSendView.m
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-23.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISKQQSendView.h"


@implementation SISKQQSendView
//@synthesize engine;
@synthesize qqSendDelegate = _qqSendDelegate;

-(id)initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if (self) {
        // Initialization code
    }
    return(self);
}

-(id)initWithText: (NSString *) text image: (UIImage *) image
{
    self = [super initWithText: text image: image];

    [titleLabel setText: NSLocalizedString(@"腾讯微博", nil)];

    return(self);
}


-(void)onSendButtonTouched: (id) sender
{
    if ([contentTextView.text isEqualToString: @""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"腾讯微博", nil)
                                                            message: NSLocalizedString(@"请输入微博内容", nil)
                                                           delegate: nil
                                                  cancelButtonTitle: NSLocalizedString(@"确定", nil) otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if ([[self qqSendDelegate] respondsToSelector: @selector(buttonActionWillSendWeibo:withImage:andMessage:)]) {
        [_qqSendDelegate buttonActionWillSendWeibo: self withImage: self.contentImage andMessage: contentTextView.text];
    }
//    [engine sendPublishWeiboWithUIImage:contentImage weiboContent:contentTextView.text];
    //    [engine sendWeiBoWithText:contentTextView.text image:contentImage];
//    [self hide:YES];
}

@end
