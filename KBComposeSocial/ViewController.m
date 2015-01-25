//
//  ViewController.m
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

#import "ViewController.h"

#import "KBComposeViewController.h"

#import "UIImage+Support.h"

#pragma mark - Class Extension

@interface ViewController () <KBComposeViewControllerDelegate>

#pragma mark - Interface Builder Outlets

@property (nonatomic) IBOutlet UIButton * buttonFacebook1;
@property (nonatomic) IBOutlet UIButton * buttonFacebook2;
@property (nonatomic) IBOutlet UIButton * buttonFacebook3;
@property (nonatomic) IBOutlet UIButton * buttonFacebook4;
@property (nonatomic) IBOutlet UIButton * buttonFacebook5;
@property (nonatomic) IBOutlet UIButton * buttonFacebook6;

@property (nonatomic) IBOutlet UIButton * buttonTwitter1;
@property (nonatomic) IBOutlet UIButton * buttonTwitter2;
@property (nonatomic) IBOutlet UIButton * buttonTwitter3;
@property (nonatomic) IBOutlet UIButton * buttonTwitter4;
@property (nonatomic) IBOutlet UIButton * buttonTwitter5;
@property (nonatomic) IBOutlet UIButton * buttonTwitter6;

@property (nonatomic) IBOutlet UILabel * labelFacebook1;
@property (nonatomic) IBOutlet UILabel * labelFacebook2;
@property (nonatomic) IBOutlet UILabel * labelFacebook3;
@property (nonatomic) IBOutlet UILabel * labelFacebook4;
@property (nonatomic) IBOutlet UILabel * labelFacebook5;
@property (nonatomic) IBOutlet UILabel * labelFacebook6;

@property (nonatomic) IBOutlet UILabel * labelTwitter1;
@property (nonatomic) IBOutlet UILabel * labelTwitter2;
@property (nonatomic) IBOutlet UILabel * labelTwitter3;
@property (nonatomic) IBOutlet UILabel * labelTwitter4;
@property (nonatomic) IBOutlet UILabel * labelTwitter5;
@property (nonatomic) IBOutlet UILabel * labelTwitter6;

#pragma mark - Interface Builder Methods

- (IBAction)pressFacebook1:(id)sender;
- (IBAction)pressFacebook2:(id)sender;
- (IBAction)pressFacebook3:(id)sender;
- (IBAction)pressFacebook4:(id)sender;
- (IBAction)pressFacebook5:(id)sender;
- (IBAction)pressFacebook6:(id)sender;

- (IBAction)pressTwitter1:(id)sender;
- (IBAction)pressTwitter2:(id)sender;
- (IBAction)pressTwitter3:(id)sender;
- (IBAction)pressTwitter4:(id)sender;
- (IBAction)pressTwitter5:(id)sender;
- (IBAction)pressTwitter6:(id)sender;

#pragma mark - Supporting Methods 

- (NSString*)sampleText;
- (UIImage*)sampleImage1;
- (UIImage*)sampleImage2;
- (NSURL*)sampleURL1;
- (NSURL*)sampleURL2;
- (void)displayViewController:(UIViewController*)controller;

@end

#pragma mark - Class Implementation

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewWillLayoutSubviews {
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ) {
        CGFloat margin1 = 16.0f;
        [self adjustView:self.buttonFacebook1 withMargin:margin1];
        [self adjustView:self.buttonFacebook2 withMargin:margin1];
        [self adjustView:self.buttonFacebook3 withMargin:margin1];
        [self adjustView:self.buttonFacebook4 withMargin:margin1];
        [self adjustView:self.buttonFacebook5 withMargin:margin1];
        [self adjustView:self.buttonFacebook6 withMargin:margin1];
        
        [self adjustView:self.buttonTwitter1 withMargin:margin1];
        [self adjustView:self.buttonTwitter2 withMargin:margin1];
        [self adjustView:self.buttonTwitter3 withMargin:margin1];
        [self adjustView:self.buttonTwitter4 withMargin:margin1];
        [self adjustView:self.buttonTwitter5 withMargin:margin1];
        [self adjustView:self.buttonTwitter6 withMargin:margin1];
        
        [self adjustView:self.labelFacebook1 withMargin:margin1];
        [self adjustView:self.labelFacebook2 withMargin:margin1];
        [self adjustView:self.labelFacebook3 withMargin:margin1];
        [self adjustView:self.labelFacebook4 withMargin:margin1];
        [self adjustView:self.labelFacebook5 withMargin:margin1];
        [self adjustView:self.labelFacebook6 withMargin:margin1];
        
        [self adjustView:self.labelTwitter1 withMargin:margin1];
        [self adjustView:self.labelTwitter2 withMargin:margin1];
        [self adjustView:self.labelTwitter3 withMargin:margin1];
        [self adjustView:self.labelTwitter4 withMargin:margin1];
        [self adjustView:self.labelTwitter5 withMargin:margin1];
        [self adjustView:self.labelTwitter6 withMargin:margin1];
    }
}

// Hack to adjust position for iOS7
- (void)adjustView:(UIView*)view1 withMargin:(CGFloat)margin {
    CGRect tmp = view1.frame;
    view1.frame = CGRectMake(tmp.origin.x, tmp.origin.y + margin, tmp.size.width, tmp.size.height);
}

#pragma mark -  IBAction Methods

//
// FACEBOOK
//
- (IBAction)pressFacebook1:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressFacebook2:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressFacebook3:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp addImage:[self sampleImage2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressFacebook4:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp addURL:[self sampleURL1]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressFacebook5:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp addURL:[self sampleURL1]];
    [comp addURL:[self sampleURL2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressFacebook6:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp addImage:[self sampleImage2]];
    [comp addURL:[self sampleURL1]];
    [comp addURL:[self sampleURL2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

//
// TWITTER
//
- (IBAction)pressTwitter1:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressTwitter2:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressTwitter3:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp addImage:[self sampleImage2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressTwitter4:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp addURL:[self sampleURL1]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressTwitter5:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp addURL:[self sampleURL1]];
    [comp addURL:[self sampleURL2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

- (IBAction)pressTwitter6:(id)sender {
    KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeTwitter];
    [comp setInitialText:[self sampleText]];
    [comp addImage:[self sampleImage1]];
    [comp addImage:[self sampleImage2]];
    [comp addURL:[self sampleURL1]];
    [comp addURL:[self sampleURL2]];
    [comp setDelegate:self];
    [self displayViewController:comp];
}

#pragma mark - Internal Methods

- (NSString*)sampleText {
    return [NSString stringWithFormat:@"Test message: %f", [[NSDate date] timeIntervalSince1970]];
}

- (UIImage*)sampleImage1 {
    return [UIImage imageWithName:@"Saturn.jpg"];
}

- (UIImage*)sampleImage2 {
    return [UIImage imageWithName:@"Sunset.jpg"];
}

- (NSURL*)sampleURL1 {
    return [NSURL URLWithString:@"http://www.google.com"];
}

- (NSURL*)sampleURL2 {
    return [NSURL URLWithString:@"http://www.yahoo.com"];
}

- (void)displayViewController:(UIViewController*)controller {
    if ( [self respondsToSelector:@selector(presentViewController:animated:completion:)] ) {
        [self presentViewController:controller animated:YES completion:NULL];
    } else if ( [self respondsToSelector:@selector(presentModalViewController:animated:)] ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self presentModalViewController:controller animated:YES];
#pragma clang diagnostic pop
    } else {
        NSLog(@"[KBComposeHeaders] - Could not display UIViewController: %@", controller);
    }
}

#pragma mark - KBComposeViewController Delegate

- (void)composeViewControllerDidPressCancel:(id)sender {
    KBComposeViewController *controller = (KBComposeViewController*)sender;
    if ( [controller isServiceTypeFacebook] )
    {
        // Facebook Cancel
        NSLog(@"++ Facebook Cancel");
        return;
    }
    
    if ( [controller isServiceTypeTwitter] )
    {
        // Twitter Cancel
        NSLog(@"++ Twitter Cancel");
        return;
    }
}

- (void)composeViewControllerDidPressPost:(id)sender {
    KBComposeViewController *controller = (KBComposeViewController*)sender;
    if ( [controller isServiceTypeFacebook] )
    {
        // Facebook Post
        NSLog(@"++ Facebook Post");
        return;
    }
    if ( [controller isServiceTypeTwitter] )
    {
        // Twitter Post
        NSLog(@"++ Twitter Post");
        return;
    }
}

@end
