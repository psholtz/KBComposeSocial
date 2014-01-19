//
//  KBComposeFacebookViewController.m
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

#import "KBComposeFacebookViewController.h"

const static NSString *facebookPostButtonName      = @"KBComposeFacebookSendButton.png";
const static NSString *facebookCancelButtonName    = @"KBComposeFacebookSendButton.png";
const static NSString *facebookNavigationImageName = @"KBComposeFacebookNavigationBar.png";
const static NSString *facebookLabelTitle          = @"Facebook";

@interface KBComposeFacebookViewController ()

@end

@implementation KBComposeFacebookViewController

#pragma mark -
#pragma mark View Lifecycle
- (id)init {
    NSString * name = nil;
    if IS_IPHONE_4 {
        name = @"KBComposeViewController_iPhone4";
    }
    else if IS_IPHONE_5 {
        name = @"KBComposeViewController_iPhone5";
    }
    else if IS_IPAD {
        name = @"KBComposeViewController_iPad";
    }
    
    self = [super initWithNibName:name bundle:nil];
    if ( self ) {
        _internalText        = KB_NULL_STRING;
        _internalImages      = [[NSMutableArray alloc] init];
        _internalUrls        = [[NSMutableArray alloc] init];
        _editable            = YES;
        
        _postButtonName      = (NSString*)facebookPostButtonName;
        _cancelButtonName    = (NSString*)facebookCancelButtonName;
        _navigationImageName = (NSString*)facebookNavigationImageName;
        _labelTitle          = (NSString*)facebookLabelTitle;
        _titleTextColor      = kbColorWhite;
        _titleShadowColor    = kbColorBlack;
        _postTextColor       = kbColorWhite;
        _postShadowColor     = kbColorBlack;
        _cancelTextColor     = kbColorWhite;
        _cancelShadowColor   = kbColorBlack;
        
        _serviceType         = KBServiceTypeFacebook;
    }
    return self;
}

@end
