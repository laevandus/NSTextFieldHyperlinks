//
//  AppDelegate.m
//  NSTextFieldHyperlinks
//
//  Created by Toomas Vahter on 25.12.12.
//  Copyright (c) 2012 Toomas Vahter. All rights reserved.
//
//  This content is released under the MIT License (http://www.opensource.org/licenses/mit-license.php).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AppDelegate.h"
#import "HyperlinkTextField.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:@"Check out this "];
    
    // Create hyperlink
    NSString *linkName = @"blog";
    NSURL *url = [NSURL URLWithString:@"http://toomasvahter.wordpress.com"];
    NSAttributedString *hyperlinkString = [self.hyperlinkTextField hyperlink:linkName toURL:url];
    [resultString appendAttributedString:hyperlinkString];
    
    NSString *plainString = @". Some pretty interesting posts.";
    [resultString appendAttributedString:[[NSAttributedString alloc] initWithString:plainString]];
    
    [self.hyperlinkTextField setAttributedStringValue:resultString];
    
    // Update existing textfield substring with hyperlink
    self.hyperlinkTextField2.linkColor = [NSColor redColor];
    [self.hyperlinkTextField2 updateSubstring:@"blog" withHyperLinkToURL:url];
    
    // Replace existing textfield content key with hyperlink
    self.hyperlinkTextField3.linkColor = [NSColor greenColor];
    [self.hyperlinkTextField3 replaceSubstring:@"$key" withHyperLink:@"blog" toURL:url];
}

@end
