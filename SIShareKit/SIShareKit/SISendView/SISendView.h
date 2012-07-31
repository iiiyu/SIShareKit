//
//  SISendView.h
//  SinaWeiBoSDK
//  Based on OAuth 2.0
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class SISendView;

@protocol SISendViewDelegate <NSObject>

@optional

@optional
- (void)sendViewWillAppear:(SISendView *)view;
- (void)sendViewDidAppear:(SISendView *)view;
- (void)sendViewWillDisappear:(SISendView *)view;
- (void)sendViewDidDisappear:(SISendView *)view;

- (void)sendViewDidFinishSending:(SISendView *)view;
- (void)sendView:(SISendView *)view didFailWithError:(NSError *)error;

- (void)sendViewNotAuthorized:(SISendView *)view;
- (void)sendViewAuthorizeExpired:(SISendView *)view;

@end


@interface SISendView : UIView <UITextViewDelegate> 
{
    
    UITextView  *contentTextView;
    UIImageView *contentImageView;
    
    UIButton    *sendButton;
    UIButton    *closeButton;
    UIButton    *clearTextButton;
    UIButton    *clearImageButton;
    
    UILabel     *titleLabel;
    UILabel     *wordCountLabel;
    
    UIView      *panelView;
    UIImageView *panelImageView;
    
    NSString    *contentText;
    UIImage     *contentImage;
    
    UIInterfaceOrientation previousOrientation;
    
    BOOL        isKeyboardShowing;
    
    
    id<SISendViewDelegate> delegate;
}

@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, assign) id<SISendViewDelegate> delegate;

- (id)initWithText:(NSString *)text image:(UIImage *)image;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
