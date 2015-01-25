//
//  UIImage+Names.m
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
//  Created by Paul Sholtz on 5/15/13.
//

#pragma mark - Defines

#define kbWidthLabel    @"width"
#define kbHeightLabel   @"height"

#import "UIImage+Support.h"

#pragma mark - UIImage Category (Support)

@implementation UIImage (Support)

#pragma mark - Loading API

//
// In older iOS SDKs there was a potential memory leak in -[UIImage imageNamed:].
// It's been fixed now, but this method can be used as a work-around.
//
+ (UIImage*)imageWithName:(NSString*)name
{
    NSArray *comps = [name componentsSeparatedByString:@"."];
    NSString *filename = [[comps subarrayWithRange:NSMakeRange(0, comps.count-1)] componentsJoinedByString:@""];
    NSString *suffix = [comps objectAtIndex:(comps.count - 1)];

    return [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:suffix]]];
}

#pragma mark - Scalaing APIs

//
// Categories for scaling the image
//
- (UIImage*)scaleToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleAspectToFit:(CGSize)targetSize {
    NSString * currentMaxDimensionLabel = self.size.width > self.size.height ? kbWidthLabel : kbHeightLabel;
    CGFloat currentMaxDimensionValue = self.size.width > self.size.height ? self.size.width : self.size.height;
    
    CGSize newSize = CGSizeZero;
    if ( [currentMaxDimensionLabel isEqualToString:kbWidthLabel] )
    {
        CGFloat factor = targetSize.width / currentMaxDimensionValue;
        newSize = CGSizeMake(targetSize.width, factor * self.size.height);
    }
    if ( [currentMaxDimensionLabel isEqualToString:kbHeightLabel] ) {
        CGFloat factor = targetSize.height / currentMaxDimensionValue;
        newSize = CGSizeMake(factor * self.size.width, targetSize.height);
    }
    
    return [self scaleToSize:newSize];
}

- (UIImage*)scaleAspectToFill:(CGSize)targetSize {
    NSString * currentMaxDimensionLabel = self.size.width > self.size.height ? kbWidthLabel : kbHeightLabel;
    
    CGSize newSize = CGSizeZero;
    if ( [currentMaxDimensionLabel isEqualToString:kbWidthLabel] )
    {
        CGFloat factor = targetSize.height / self.size.height;
        newSize = CGSizeMake(factor * self.size.width, targetSize.height);
    }
    if ( [currentMaxDimensionLabel isEqualToString:kbHeightLabel] )
    {
        CGFloat factor = targetSize.width / self.size.width;
        newSize = CGSizeMake(targetSize.width, factor * self.size.height);
    }
    
    return [self scaleToSize:newSize];
}

@end
