//
//  SIBaseDialogViewController.h
//  OpenSdkTest
//
//  Created by ChenYu Xiao on 12-7-17.
//  Copyright (c) 2012年 sumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIBaseDialogViewController : UIViewController {
    UIView *_backgroundView;
    UIButton *_cancelButton;
    BOOL _showingKeyboard;
    UIDeviceOrientation _orientation;
}

@property ( nonatomic)UIView *backgroundView;
@property ( nonatomic)UIButton *cancelButton;

- (void)show;
- (void)close;
- (void)updateSubviewOrientation;
- (void)sizeToFitOrientation:(BOOL)transform;
- (CGRect)fitOrientationFrame;


@end
