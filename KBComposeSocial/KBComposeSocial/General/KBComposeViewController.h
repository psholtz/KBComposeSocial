//
//  KBComposeViewController.h
//  KBComposeSocial
//
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

#import <UIKit/UIKit.h>

#import "KBComposeHeaders.h"

#pragma mark - Defines

#define KB_GUARD_POSTING_NULL_STRING            1

@class KBComposeTextView;
@class KBComposeSheetView;

#pragma mark - KBComposeViewController Protocol

@protocol KBComposeViewControllerDelegate <NSObject>

#pragma mark - Optional

@optional
- (void)composeViewControllerDidPressCancel:(id)sender;
- (void)composeViewControllerDidPressPost:(id)sender;

@end

// Types of Compose Controllers
typedef enum {
    KBServiceTypeFacebook,
    KBServiceTypeTwitter,
} KBServiceTypeConstant;

#pragma mark - Class Interface

@interface KBComposeViewController : UIViewController {
@protected
    NSString        * _internalText;
    NSMutableArray  * _internalImages;
    NSMutableArray  * _internalUrls;
    NSInteger         _attachmentsCount;
    
    KBServiceTypeConstant _serviceType;
    
    BOOL _editable;
    
    // Non-IB Properties for the Interface (set in child classes)
    NSString * _postButtonName;
    NSString * _cancelButtonName;
    NSString * _navigationImageName;
    NSString * _labelTitle;
    UIColor  * _titleTextColor;
    UIColor  * _titleShadowColor;
    UIColor  * _postTextColor;
    UIColor  * _postShadowColor;
    UIColor  * _cancelTextColor;
    UIColor  * _cancelShadowColor;
}

#pragma mark - Interface Builder Outlets

// Common IB Properties between subclasses
@property (nonatomic, KB_WEAK) IBOutlet KBComposeTextView  * textView;
@property (nonatomic, KB_WEAK) IBOutlet KBComposeSheetView * sheetView;

@property (nonatomic, KB_WEAK) IBOutlet UIView      * textViewContainer;
@property (nonatomic, KB_WEAK) IBOutlet UIImageView * navImage;
@property (nonatomic, KB_WEAK) IBOutlet UILabel     * navLabel;
@property (nonatomic, KB_WEAK) IBOutlet UILabel     * countLabel;
@property (nonatomic, KB_WEAK) IBOutlet UIButton    * cancelButton;
@property (nonatomic, KB_WEAK) IBOutlet UIButton    * postButton;
@property (nonatomic, KB_WEAK) IBOutlet UIImageView * cardHeaderLineView;
@property (nonatomic, KB_WEAK) IBOutlet UIImageView * attachment1FrameView;
@property (nonatomic, KB_WEAK) IBOutlet UIImageView * attachment1ImageView;
@property (nonatomic, KB_WEAK) IBOutlet UIImageView * paperClipView;

#pragma mark - Properties 

@property (nonatomic, assign)  KBServiceTypeConstant serviceType;

@property (nonatomic, KB_WEAK) id<KBComposeViewControllerDelegate> delegate;

// Used to make sure we are within the 140 Tweet limit
@property (nonatomic, readonly) NSInteger postLength;
@property (nonatomic, readonly) NSInteger remainingChars;

// Data Items (to be passed on to social services)
@property (nonatomic, copy, readonly)   NSString * text;
@property (nonatomic, strong, readonly) NSArray  * images;
@property (nonatomic, strong, readonly) NSArray  * urls;
@property (nonatomic, assign, readonly) NSInteger  attachmentsCount;

#pragma mark - Class Methods
//
// Constructors
//
+ (id)composeViewControllerForServiceType:(KBServiceTypeConstant)serviceType;

#pragma mark - Instance Methods
//
// Check Service Type
//
- (BOOL)isServiceTypeFacebook;
- (BOOL)isServiceTypeTwitter;

//
// Composiing Posts
//
- (BOOL)setInitialText:(NSString*)text;
- (BOOL)addImage:(UIImage*)image;
- (BOOL)removeAllImages;
- (BOOL)addURL:(NSURL*)url;
- (BOOL)removeAllURLs;

//
// IBAction Methods
//
- (IBAction)pressPost:(id)sender;
- (IBAction)pressCancel:(id)sender;

@end
