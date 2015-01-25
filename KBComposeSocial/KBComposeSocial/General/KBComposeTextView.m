//
//  KBComposeTextView.m
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

#import "KBComposeTextView.h"

#import "KBComposeHeaders.h"

#import "KBComposeRuledView.h"

#pragma mark - Class Extension

@interface KBComposeTextView ()

#pragma mark - Properties 

@property (nonatomic, readonly) CGRect ruledViewFrame;
@property (nonatomic, strong) KBComposeRuledView * ruledView;

@end

#pragma mark - Class Implementation

@implementation KBComposeTextView

#pragma mark - Accessors

- (CGRect)ruledViewFrame {
    CGFloat extraForBounce = 200.0f;
    CGFloat width = 1024.0f;
    CGFloat textAlignmentOffset = -2.0f;
    
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        textAlignmentOffset = 5.0f;
    }
    
    CGRect f = CGRectMake(0.0f,
                          -extraForBounce + textAlignmentOffset,
                          width,
                          self.contentSize.height + 2 * extraForBounce);
    
    return f;
}

#pragma mark - View Lifecycle

- (void)layoutSubviews {
    self.clipsToBounds = YES;
    
    _ruledView = [[KBComposeRuledView alloc] initWithFrame:self.ruledViewFrame];
    self.ruledView.lineColor = [UIColor colorWithWhite:0.5f alpha:0.15f];
    self.ruledView.lineWidth = 1.0f;
    self.ruledView.rowHeight = self.font.lineHeight;
    [self insertSubview:self.ruledView atIndex:0];
}

@end
