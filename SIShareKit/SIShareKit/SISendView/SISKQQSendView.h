//
//  SISKQQSendView.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-23.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import "SISendView.h"

@class SISKQQSendView;

@protocol SISKQQSendViewDelegate <NSObject>
@optional
- (void)buttonActionWillSendWeibo:(SISKQQSendView *)sendView
                        withImage:(UIImage *)image 
                       andMessage:(NSString *)message;
@end

@interface SISKQQSendView : SISendView

@property (unsafe_unretained, nonatomic) id<SISKQQSendViewDelegate> qqSendDelegate;

//- (id)initWithText:(NSString *)text image:(UIImage *)image engine:(SISKTXWeiboEngine *)txEngine;

- (id)initWithText:(NSString *)text image:(UIImage *)image;

@end