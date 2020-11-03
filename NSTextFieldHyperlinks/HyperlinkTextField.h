//
//  HyperlinkTextField.h
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

#import <Cocoa/Cocoa.h>

// link option keys
extern NSString * HTLinkOption;
extern NSString * HTUrlOption;
extern NSString * HTColorOption;

@interface HyperlinkTextField : NSTextField

@property (strong) NSCursor *cursor;

/*!
 
 Explicity enable and disable hyperlinks.
 
 */
@property (assign) BOOL hyperlinksEnabled;

/*!
 
 Link color
 
 */
@property (strong) NSColor *linkColor;

/*!
 
 Update control attributed string with link options to define hyperlink.
 
 */
- (void)updateAttributedStringValueWithLinkOptions:(NSArray <NSDictionary <NSString *, NSObject *> *>*)options;

/*!
 
 Set control string with link options to define hyperlink.
 
 */
- (void)setStringValue:(NSString *)stringValue linkOptions:(NSArray <NSDictionary <NSString *, NSObject *> *>*)options;

/*!
 
 Set control string with attributes and link options to define hyperlink.
 
 */
- (void)setStringValue:(NSString *)stringValue attributes:(NSDictionary<NSString *, id> *)attributes linkOptions:(NSArray <NSDictionary <NSString *, NSObject *> *>*)options;

/*!
 
 Update control substring with hyperlink to given URL
 
 */
- (void)updateSubstring:(NSString *)linktext withHyperLinkToURL:(NSURL *)linkURL;

/*!
 
 Update control substring with hyperlink to given URL
 
 */
- (void)replaceSubstring:(NSString *)linkKey withHyperLink:(NSString *)linktext toURL:(NSURL *)linkURL;

/*!
 
 Make hyperlink attributed string to given URL
 
 */
- (NSAttributedString *)hyperlink:(NSString *)linktext toURL:(NSURL *)linkURL;

@end

@interface NSString (HyperTextField)
- (NSAttributedString *)htf_hyperlinkToURL:(NSURL *)linkURL;
- (NSAttributedString *)htf_hyperlinkToURL:(NSURL *)linkURL linkColor:(NSColor *)linkColor;
- (NSAttributedString *)htf_hyperlinkToURL:(NSURL *)linkURL linkColor:(NSColor *)linkColor font:(NSFont *)font;
- (NSAttributedString *)htf_hyperlinkWithAttributes:(NSDictionary<NSString *, id> *)attributes linkOptions:(NSArray <NSDictionary <NSString *, NSObject *> *>*)options;
@end

@interface NSAttributedString (HyperTextField)

- (NSAttributedString *)htf_replaceSubstringWithHyperLink:(NSString *)linktext toURL:(NSURL *)linkURL;

- (NSAttributedString *)htf_replaceSubstringWithHyperLink:(NSString *)linktext
                                                    toURL:(NSURL *)linkURL
                                                linkColor:(NSColor *)linkColor;

- (NSAttributedString *)htf_replaceSubstring:(NSString *)linkKey
                               withHyperLink:(NSString *)linktext
                                       toURL:(NSURL *)linkURL
                                   linkColor:(NSColor *)linkColor;
@end

