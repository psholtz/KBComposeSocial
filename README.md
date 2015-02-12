KBComposeSocial
===============

<img src="http://farm6.staticflickr.com/5492/12025528914_97b1b11047.jpg" />

KBComposeSocial provides custom iOS-style dialog boxes for posting to Facebook and Twitter.

The SDK can be configured to capture any of four different media types:

<ul>
<li>Text only</li>
<li>Text and an image array</li>
<li>Text and a URL array</li>
<li>Text, an image array and a URL array</li>
</ul>

A delegate protocol, with two optional callbacks, is provided:

<pre>
@protocol KBComposeViewControllerDelegate <NSObject>

@optional
- (void)composeViewControllerDidPressCancel:(id)sender;
- (void)composeViewControllerDidPressPost:(id)sender;

@end
</pre>

Clients using the SDK should implement and use the <code>composeViewControllerDidPressPost:</code> API to link with the Facebook and/or Twitter Social SDK implementation of their choice.

Important Note
-------------- 

<b>THIS SOFTWARE DOES NOT ACTUALLY POST TO FACEBOOK OR TWITTER!</b>

Rather, it offers user interface controls you can use to capture text, images and urls from your users.

Clients wishing to forward collected information onto the social networks must link with the Facebook and/or Twitter Social SDK implementation of their choice in the <code>composeViewControllerDidPressPost:</code> API.

Example Usage 
------------- 

You can present a Facebook dialog box using code similar to the following:

<pre>
KBComposeViewController *comp = [KBComposeViewController composeViewControllerForServiceType:KBServiceTypeFacebook];
[comp setInitialText:@"Hello, Facebook!"];
[comp setDelegate:self];
[self displayViewController:comp];
</pre>

Running this code would cause the user to be presented with a dialog box similar to the following:

<img src="http://farm4.staticflickr.com/3828/12024234055_3785c07817.jpg" />

To respond to the input entered by the user, you would implement the <code>composeViewControllerDidPressPost:</code> API as follows:

<pre>
- (void)composeViewControllerDidPressPost:(id)sender {
    KBComposeViewController *controller = (KBComposeViewController*)sender;
    NSLog(@"++ This is text: %@", controller.text);
    NSLog(@"++ This is image array: %@", controller.images);
    NSLog(@"++ This is url array: %@", controller.urls);
    NSLog(@"++ This is number of attachments: %d", controller.attachmentsCount);

    // TODO: Extract text, images and urls, and post to Facebook/Twitter using your SDK
}
</pre>

This code will be invoked when the user presses the <code>Post</code> button, which is the desired behavior.

Support
------- 

KBComposeSocial is designed to run on all iOS devices (iPhone4, iPhone5 and iPad) and on all iOS versions from 4.3 and up.

KBComposeSocial is designed to be used on ARC-enabled projects.

KBComposeSocial requires linking with the QuartzCore framework.

License
------- 

This code is distributed under the terms and conditions of the MIT license.

Change Log
---------- 

<b>Version 1.1</b> @ February 11, 2015.

<ul>
<li>Support for iOS7, iOS8.</li>
<li>Other minor updates.</li>
</ul>

<b>Version 1.0</b> @ January 18, 2014.

<ul>
<li>Initial Release.</li>
</ul>