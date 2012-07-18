//
//  SISKViewController.h
//  SIShareKit
//
//  Created by ChenYu Xiao on 12-7-18.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SISKViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSend;

@end
