//
//  KBComposeTwitterViewController.m
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

#import "KBComposeTwitterViewController.h"

const static NSString * twitterPostButtonImageName   = @"KBComposeTwitterSendButton.png";
const static NSString * twitterCancelButtonImageName = @"KBComposeTwitterCancelButton.png";
const static NSString * twitterNavigationImageName   = @"KBComposeTwitterNavigationBar.png";

#pragma mark - Class Extension

@interface KBComposeTwitterViewController ()

@property (nonatomic, copy) NSString * twitterLabelTitle;

@end

#pragma mark - Class Implementation

@implementation KBComposeTwitterViewController

#pragma mark - View Lifecycle

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
    if (self) {
        _internalText        = KB_NULL_STRING;
        _internalImages      = [[NSMutableArray alloc] init];
        _internalUrls        = [[NSMutableArray alloc] init];
        _editable            = YES;
        _twitterLabelTitle   = [NSLocalizedStringFromTableInBundle(@"Tweet", nil, KB_MAIN_BUNDLE, nil) copy];
        
        _postButtonImageName   = (NSString*)twitterPostButtonImageName;
        _cancelButtonImageName = (NSString*)twitterCancelButtonImageName;
        _navigationImageName   = (NSString*)twitterNavigationImageName;
        _labelTitle          = (NSString*)_twitterLabelTitle;
        _titleTextColor      = kbColorGray;
        _titleShadowColor    = kbColorWhite;
        _postTextColor       = kbColorWhite;
        _postShadowColor     = kbColorBlack;
        _cancelTextColor     = kbColorGray;
        _cancelShadowColor   = kbColorWhite;
        
        _serviceType         = KBServiceTypeTwitter;
    }
    return self;
}

@end
