//
//  KBComposeViewController.m
//  KBComposeSocial
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  Created by Paul Sholtz on 5/16/13.
//

#import "KBComposeViewController.h"
#import "KBComposeFacebookViewController.h"
#import "KBComposeTwitterViewController.h"
#import "KBComposeTextView.h"
#import "KBComposeSheetView.h"

#import "UIImage+Support.h"
#import "NSString+Support.h"

#import <QuartzCore/QuartzCore.h>

static const NSUInteger KB_TWEET_MAX_LENGTH    = 140;
static const NSUInteger KB_TWEET_IMAGE_SIZE    = 23;
static const NSUInteger KB_TWEET_URL_BASE_SIZE = 18;

@interface KBComposeViewController () <UITextViewDelegate>

// Internal Methods for UI
- (void)updateAttachments;
- (void)updateFramesForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)updateCountLabel;
- (void)hideViewController;

@end

@implementation KBComposeViewController

#pragma mark -
#pragma mark Accessors
- (NSString*)text {
    return _internalText;
}

- (NSArray*)images {
    return _internalImages;
}

- (NSArray*)urls {
    return _internalUrls;
}

- (NSInteger)attachmentsCount {
    return [self.images count] + [self.urls count];
}

- (NSInteger)postLength {
    int length = 0;
    
    // Get the size of Text
    length += _editable ? _internalText.length : self.textView.text.length;
    
    // Get the size of Images
    length += KB_TWEET_IMAGE_SIZE * self.images.count;
    
    // Get the size of URLs
    for ( NSURL * url in self.urls ) {
        length += [url scheme].length + KB_TWEET_URL_BASE_SIZE;
    }
    
    // Get the number of spaces
    if ( self.attachmentsCount > 0 ) {
        length += self.attachmentsCount - 1;
    }
    
    return length;
}

- (NSInteger)remainingChars {
    return KB_TWEET_MAX_LENGTH - self.postLength;
}

#pragma mark -
#pragma mark Constructors
+ (id)composeViewControllerForServiceType:(KBServiceTypeConstant)serviceType {
    // Construct correct type
    KBComposeViewController * controller = nil;
    switch ( serviceType ) {
        case KBServiceTypeFacebook:
            controller = [[KBComposeFacebookViewController alloc] init];
            break;
        case KBServiceTypeTwitter:
            controller = [[KBComposeTwitterViewController alloc] init];
            break;
    }
    return controller;
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show slight "flash" on startup
    self.view.layer.backgroundColor = kbColorLight.CGColor;
    [UIView animateWithDuration:1.0f
                     animations:^(void) {
                         self.view.layer.backgroundColor = kbColorDark.CGColor;
                     }];
    
    // Configure the UI elements
    self.textViewContainer.backgroundColor = [UIColor clearColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = self.text;
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    self.attachment1ImageView.clipsToBounds = YES;
    self.attachment1ImageView.layer.cornerRadius = 4.0f;
    
    self.navLabel.text = _labelTitle;
    [self.navLabel setTextColor:_titleTextColor];
    [self.navLabel setShadowColor:_titleShadowColor];
    
    [self.postButton setTitleColor:_postTextColor forState:UIControlStateNormal];
    [self.postButton setTitleColor:kbColorWhite forState:UIControlStateHighlighted];
    [self.postButton setTitleShadowColor:_postShadowColor forState:UIControlStateNormal];
    [self.postButton setTitleShadowColor:kbColorBlack forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:_cancelTextColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kbColorWhite forState:UIControlStateHighlighted];
    [self.cancelButton setTitleShadowColor:_cancelShadowColor forState:UIControlStateNormal];
    [self.cancelButton setTitleShadowColor:kbColorBlack forState:UIControlStateHighlighted];
    
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textColor = kbColorGray;
    self.countLabel.shadowColor = kbColorWhite;
    self.countLabel.hidden = (self.serviceType == KBServiceTypeFacebook);
    self.cardHeaderLineView.hidden = (self.serviceType == KBServiceTypeFacebook);
    
    // Configure frames for orientation
    [self updateFramesForOrientation:self.interfaceOrientation];
    [self updateAttachments];
}

- (void)viewDidAppear:(BOOL)animated {
    // Configure frames for orientation
    [self updateFramesForOrientation:self.interfaceOrientation];
    
    // Cannot update InitialText, Images and URLs while view is showing
    _editable = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    // Restore updating of InitialText, Images and URLs 
    _editable = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return TRUE;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateFramesForOrientation:interfaceOrientation];
}

#pragma mark -
#pragma mark Check Service Type
- (BOOL)isServiceTypeFacebook {
    return self.serviceType == KBServiceTypeFacebook;
}
- (BOOL)isServiceTypeTwitter {
    return self.serviceType == KBServiceTypeTwitter;
}

#pragma mark -
#pragma mark Composing Posts
- (BOOL)setInitialText:(NSString*)text {
    if ( !_editable ) return FALSE;
  
    // Do a length check for Twitter
    if ( _serviceType == KBServiceTypeTwitter ) {
        // Allow for space by adding 1
        if ( self.postLength + text.length + 1 > KB_TWEET_MAX_LENGTH ) {
            return FALSE;
        }
    }
    
    // Set the image and return if we are OK
    _internalText = [NSString stringWithString:text];
    return TRUE;
}

- (BOOL)addImage:(UIImage*)image {
    if ( !_editable ) return FALSE;

    // Check the length for Twitter
    if ( _serviceType == KBServiceTypeTwitter ) {
        // Allow for space by adding 1
        if ( self.postLength + KB_TWEET_IMAGE_SIZE + 1 > KB_TWEET_MAX_LENGTH ) {
            return FALSE;
        }
    }

    // Add image and return if we are OK 
    [_internalImages addObject:image];
    return TRUE;
}

- (BOOL)removeAllImages {
    if ( !_editable ) return FALSE;
    
    // Remove and turn if we are editable
    [_internalImages removeAllObjects];
    return TRUE;
}

- (BOOL)addURL:(NSURL*)url {
    if ( !_editable ) return FALSE;
 
    // Check the length for Twitter
    if ( _serviceType == KBServiceTypeTwitter ) {
        // Allow for space by adding 1
        if ( self.postLength + [url scheme].length + KB_TWEET_URL_BASE_SIZE + 1 > KB_TWEET_MAX_LENGTH ) {
            return FALSE;
        }
    }

    // Add URL and return if we are OK
    [_internalUrls addObject:url];
    return TRUE;
}

- (BOOL)removeAllURLs {
    if ( !_editable ) return FALSE;
    
    // Remove and return if we are editable
    [_internalUrls removeAllObjects];
    return TRUE;
}

#pragma mark -
#pragma mark IBAction Methods
- (IBAction)pressPost:(id)sender {
    _internalText = [self.textView.text trim];
    
#if KB_GUARD_POSTING_NULL_STRING
    // Abort if we are guarding null strings
    if ( self.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Please enter a non-null string!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.textView.text = (NSString*)KB_NULL_STRING;
        return;
    }
#endif
    
    [self hideViewController];
    
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(composeViewControllerDidPost:)] ) {
        [self.delegate composeViewControllerDidPost:self];
    }
}

- (IBAction)pressCancel:(id)sender {
    [self hideViewController];
    
    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(composeViewControllerDidCancel:)] ) {
        [self.delegate composeViewControllerDidCancel:self];
    }
}

#pragma mark -
#pragma mark Internal Methods
- (void)updateFramesForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Implement in subclasses
    CGFloat buttonHorizontalMargin = 8.0f, buttonTop = 0.0f;
    CGFloat cardLeft = 0.0f, cardTop = 0.0f, cardWidth = 0.0f, cardHeight = 0.0f;
    CGFloat paperLeft = 0.0f, paperTop = 0.0f, paperWidth = 0.0f, paperHeight = 0.0f;
    CGFloat frameLeft = 0.0f, frameTop = 0.0f;
    CGFloat imageLeft = 0.0f, imageTop = 0.0f;
    CGFloat countLeft = 0.0f, countTop = 0.0f, countWidth = 50.0f, countHeight = 21.0f;
    CGFloat cardHeaderLineTop = 0.0f;
    CGFloat cardHeaderLineWidth = 0.0f;
    UIImage *postButtonImage = nil;
    UIImage *cancelButtonImage = nil;
    
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    if IS_IPHONE {
        postButtonImage = [[UIImage imageWithName:_postButtonName] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        cancelButtonImage = [[UIImage imageWithName:_cancelButtonName] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        cardWidth = CGRectGetWidth(self.view.bounds) - 10.0f;
        if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) ) {
            buttonTop = 7.0f; cardHeaderLineTop = _serviceType == KBServiceTypeFacebook ? 41.0f : 42.0f; cardHeaderLineWidth = 312.0f;
            
            cardLeft  = 4.0f;   cardTop  = 26.0f; cardWidth  = 312.0f; cardHeight  = 189.0f;
            paperLeft = 243.0f; paperTop = 70.0f; paperWidth = 79.0;   paperHeight = 34.0f;
            imageLeft = 233.0f; imageTop = 60.0f;
            frameLeft = 230.0f; frameTop = 58.0f;
            countLeft = 260.0f; countTop = 160.0f;
        } else {
            buttonTop = 6.0f;
            cardHeaderLineTop = _serviceType == KBServiceTypeFacebook ? 41.0f : 42.0f;
            
            cardLeft  = 4.0f;   cardTop  = 4.0f;  cardWidth  = IS_IPHONE_5 ? 560.0f : 472.0f; cardHeight = statusBarHidden ? 145.0f : 130.0f; cardHeaderLineWidth = IS_IPHONE_5 ? 560.0f : 472.0f;
            paperLeft = IS_IPHONE_5 ? 490.0f : 402.0f; paperTop = 49.0f; paperWidth = 79.0;   paperHeight = 34.0f;
            imageLeft = IS_IPHONE_5 ? 480.0f : 392.0f; imageTop = 55.0f;
            frameLeft = IS_IPHONE_5 ? 477.0f : 389.0f; frameTop = 53.0f;
            if IS_IPHONE_4 {
                countLeft = self.attachmentsCount > 0 ? 340.0f : 420.0f; countTop = 104.0f;
            }
            else if IS_IPHONE_5 {
                countLeft = self.attachmentsCount > 0 ? 428.0f : 508.0f; countTop = 104.0f;
            }
        }
    }
    else if IS_IPAD {
        postButtonImage = [[UIImage imageWithName:_postButtonName] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        cancelButtonImage = [[UIImage imageWithName:_cancelButtonName] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
        buttonTop = 7.0f; cardHeaderLineTop = _serviceType == KBServiceTypeFacebook ? 41.0f : 42.0f; cardHeaderLineWidth = 540.0f;
        
        if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) ) {
            cardLeft = 114.0f; cardTop = 236.0f;
            paperLeft = 583.0f; paperTop = 282.0f;
        } else {
            cardLeft = 242.0f;  cardTop = 112.0f;
            paperLeft = 709.0f; paperTop = 157.0f;
        }
        cardWidth = 540.0f; cardHeight = 189.0f;
        paperWidth = 79.0f; paperHeight = 34.0f;
        frameLeft = 462.0f; frameTop = 56.0f;
        imageLeft = 465.0f; imageTop = 58.0f;
        countLeft = 486.0f; countTop = 160.0f;
    }
    
    self.sheetView.frame = CGRectMake(cardLeft, cardTop, cardWidth, cardHeight);
    self.paperClipView.frame = CGRectMake(paperLeft, paperTop, paperWidth, paperHeight);
    self.attachment1FrameView.frame = CGRectMake(frameLeft, frameTop, 73.0f, 73.0f);
    self.attachment1ImageView.frame = CGRectMake(imageLeft, imageTop, 68.0f, 68.0f);
    self.navImage.image = [UIImage imageWithName:_navigationImageName];
    self.navImage.frame = CGRectMake(0.0f, 0.0f, cardWidth, 44.0f);
    self.navLabel.frame = CGRectMake(0.0f, 11.0f, cardWidth, 21.0f);
    self.countLabel.frame = CGRectMake(countLeft, countTop, countWidth, countHeight);
    
    // Configure CG Layer for navimage
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.navImage.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(13.0f, 13.0f)];
    [roundedPath closePath];
    maskLayer.path = [roundedPath CGPath];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.navImage.layer.mask = maskLayer;
    [self.navImage setNeedsDisplay];
    
    [self.cancelButton setBackgroundImage:cancelButtonImage forState:UIControlStateNormal];
    [self.cancelButton setFrame:CGRectMake(buttonHorizontalMargin,
                                           buttonTop,
                                           self.cancelButton.frame.size.width,
                                           cancelButtonImage.size.height)];
    
    [self.postButton setBackgroundImage:postButtonImage forState:UIControlStateNormal];
    [self.postButton setFrame:CGRectMake(self.sheetView.bounds.size.width - buttonHorizontalMargin - self.postButton.frame.size.width,
                                         buttonTop,
                                         self.postButton.frame.size.width,
                                         postButtonImage.size.height)];
    
    self.cardHeaderLineView.frame = CGRectMake(0.0f,
                                               cardHeaderLineTop,
                                               cardHeaderLineWidth,
                                               self.cardHeaderLineView.frame.size.height);
    
    CGFloat textWidth = CGRectGetWidth(self.sheetView.bounds);
    if ( self.attachmentsCount > 0 ) {
        textWidth -= CGRectGetWidth(self.attachment1FrameView.frame) + 10.0f;
    }
    CGFloat textTop = CGRectGetMaxY(self.cardHeaderLineView.frame);
    CGFloat textHeight = self.sheetView.bounds.size.height - textTop;
    if ( _serviceType == KBServiceTypeTwitter ) {
        textHeight -= 22.0f;
    }
    
    self.textViewContainer.frame = CGRectMake(0.0f,
                                              textTop,
                                              self.sheetView.bounds.size.width,
                                              textHeight);
    self.textView.frame = CGRectMake(0.0f,
                                     0.0f,
                                     textWidth,
                                     self.textViewContainer.frame.size.height - 6.0f);
    
    [self updateCountLabel];
}

- (void)updateAttachments {
    CGRect frame = self.textView.frame;
    if ( self.attachmentsCount > 0 ) {
        frame.size.width = self.sheetView.frame.size.width - self.attachment1FrameView.frame.size.width;
    }
    else {
        frame.size.width = self.sheetView.frame.size.width;
    }
    self.textView.frame = frame;
    
    self.paperClipView.hidden = YES;
    self.attachment1FrameView.hidden = YES;
    
    if ( self.attachmentsCount >= 1 ) {
        self.paperClipView.hidden = NO;
        self.attachment1FrameView.hidden = NO;
        if ( self.images.count > 0 )
        {
            self.attachment1ImageView.image = [[self.images objectAtIndex:0] scaleAspectToFill:self.attachment1ImageView.frame.size];
        } else if ( self.urls.count > 0 )
        {
            self.attachment1ImageView.image = [UIImage imageWithName:@"KBComposeURLAttachment.png"];
            
        }
    }
}

- (void)updateCountLabel {
    self.countLabel.text = [NSString stringWithFormat:@"%d", self.remainingChars];
}

- (void)hideViewController {
    if ( [self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)] ) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else if ( [self respondsToSelector:@selector(dismissModalViewControllerAnimated:)] ) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        NSLog(@"[KBComposeHeaders] - Could not dismiss UIViewController: %@", self);
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self updateCountLabel];
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ( _serviceType == KBServiceTypeTwitter ) {
        // Special handling for TWITTER
        NSInteger length = self.remainingChars;
        if ( length > 0 ) {
            // length has not yet reached the max
            return YES;
        }
        else if ( length == 0 ) {
            // accept the backspace, otherwise no
            const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            if ( isBackSpace == -8 ) {
                return YES;
            }
        }
        return NO;
    }
    
    // For others, i.e., FACEBOOK, its OK
    return YES; 
}

@end
