//
//  HyperlinkTextField.m
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

NSString * HTLinkOption = @"link";
NSString * HTUrlOption = @"url";
NSString * HTColorOption = @"color";

#import "HyperlinkTextField.h"

@interface HyperlinkTextField ()
@property (nonatomic, readonly) NSArray *hyperlinkInfos;
@property (nonatomic, readonly) NSTextView *textView;

- (void)_resetHyperlinkCursorRects;
@end

#define kHyperlinkInfoCharacterRangeKey @"range"
#define kHyperlinkInfoURLKey            @"url"
#define kHyperlinkInfoRectKey           @"rect"

@implementation HyperlinkTextField

- (void)_hyperlinkTextFieldInit
{
    [self setEditable:NO];
    [self setSelectable:NO];
    _linkColor = [NSColor blueColor];
}


- (id)initWithFrame:(NSRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self _hyperlinkTextFieldInit];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        [self _hyperlinkTextFieldInit];
    }
    
    return self;
}


- (void)resetCursorRects
{
    [super resetCursorRects];
    [self _resetHyperlinkCursorRects];
}


- (void)_resetHyperlinkCursorRects
{
    for (NSDictionary *info in self.hyperlinkInfos)
    {
        [self addCursorRect:[[info objectForKey:kHyperlinkInfoRectKey] rectValue] cursor:[NSCursor pointingHandCursor]];
    }
}


#pragma mark -
#pragma mark Accessors

- (NSArray *)hyperlinkInfos
{
    NSMutableArray *hyperlinkInfos = [[NSMutableArray alloc] init];
    NSRange stringRange = NSMakeRange(0, [self.attributedStringValue length]);
    __block NSTextView *textView = self.textView;
    [self.attributedStringValue enumerateAttribute:NSLinkAttributeName inRange:stringRange options:0 usingBlock:^(id value, NSRange range, BOOL *stop)
    {
        if (value)
        {
            NSUInteger rectCount = 0;
            NSRectArray rectArray = [textView.layoutManager rectArrayForCharacterRange:range withinSelectedCharacterRange:range inTextContainer:textView.textContainer rectCount:&rectCount];
            for (NSUInteger i = 0; i < rectCount; i++)
            {
                [hyperlinkInfos addObject:@{kHyperlinkInfoCharacterRangeKey : [NSValue valueWithRange:range], kHyperlinkInfoURLKey : value, kHyperlinkInfoRectKey : [NSValue valueWithRect:rectArray[i]]}];
            }
        }
    }];
    
    return [hyperlinkInfos count] ? hyperlinkInfos : nil;
}


- (NSTextView *)textView
{
    // Font used for displaying and frame calculations must match
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedStringValue];
    NSFont *font = [attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    
    if (!font)
        [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [attributedString length])];
    
    NSRect textViewFrame = [self.cell titleRectForBounds:self.bounds];
    NSTextView *textView = [[NSTextView alloc] initWithFrame:textViewFrame];
    [textView.textStorage setAttributedString:attributedString];

    return textView;
}


#pragma mark -
#pragma mark Mouse Events

- (void)mouseUp:(NSEvent *)theEvent
{
    NSTextView *textView = self.textView;
    NSPoint localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSUInteger index = [textView.layoutManager characterIndexForPoint:localPoint inTextContainer:textView.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (index != NSNotFound)
    {
        for (NSDictionary *info in self.hyperlinkInfos)
        {
            NSRange range = [[info objectForKey:kHyperlinkInfoCharacterRangeKey] rangeValue];
            if (NSLocationInRange(index, range))
            {
                NSURL *url = [info objectForKey:kHyperlinkInfoURLKey];
                [[NSWorkspace sharedWorkspace] openURL:url];
            }
        }
    }
}

#pragma mark -
#pragma mark Substring value updating

- (void)updateSubstring:(NSString *)linktext withHyperLinkToURL:(NSURL *)linkURL
{
    [self replaceSubstring:linktext withHyperLink:linktext toURL:linkURL];
}

- (void)replaceSubstring:(NSString *)linkKey withHyperLink:(NSString *)linktext toURL:(NSURL *)linkURL
{
    // get substring
    NSString *sourceString = self.stringValue;
    NSRange linkrange = [sourceString rangeOfString:linkKey];
    if (linkrange.location == NSNotFound) {
        return;
    }
    
    
    // build new attributed string containg the hyperlink
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:sourceString];
    attrString = [attrString htf_replaceSubstring:linkKey withHyperLink:linktext toURL:linkURL linkColor:self.linkColor];
    
    // update the control attributed string value
    [self setAttributedStringValue:attrString];
}

#pragma mark -
#pragma mark Link building

- (NSAttributedString *)hyperlink:(NSString *)linktext toURL:(NSURL *)linkURL
{
    NSAttributedString *hyperlinkString = [linktext htf_hyperlinkToURL:linkURL linkColor:self.linkColor];
    
    return hyperlinkString;
}

- (void)setStringValue:(nonnull NSString *)stringValue linkOptions:(nonnull NSArray <NSDictionary <NSString *, NSObject *> *>*)options
{
    NSAttributedString *hyperlinkText = [[NSAttributedString alloc] initWithString:stringValue];
    for (NSDictionary *option in options) {
        hyperlinkText = [hyperlinkText htf_replaceSubstringWithHyperLink:option[HTLinkOption]
                                                                   toURL:option[HTUrlOption]
                                                               linkColor:option[HTColorOption]];
    }
    
    self.attributedStringValue = hyperlinkText;
}

@end


@implementation NSString (HyperTextField)

- (NSAttributedString *)htf_hyperlinkToURL:(NSURL *)linkURL linkColor:(NSColor *)linkColor
{
    NSMutableAttributedString *hyperlinkString = [[NSMutableAttributedString alloc] initWithString:self];
    [hyperlinkString beginEditing];
    [hyperlinkString addAttribute:NSLinkAttributeName value:linkURL range:NSMakeRange(0, [hyperlinkString length])];
    [hyperlinkString addAttribute:NSForegroundColorAttributeName value:linkColor range:NSMakeRange(0, [hyperlinkString length])];
    [hyperlinkString endEditing];
    
    return hyperlinkString;
}
@end

@implementation NSAttributedString (HyperTextField)

- (NSAttributedString *)htf_replaceSubstringWithHyperLink:(NSString *)linktext
                                                    toURL:(NSURL *)linkURL
                                                linkColor:(NSColor *)linkColor
{
    return [self htf_replaceSubstring:linktext withHyperLink:linktext toURL:linkURL linkColor:linkColor];
}

- (NSAttributedString *)htf_replaceSubstring:(NSString *)linkKey
                           withHyperLink:(NSString *)linktext
                                   toURL:(NSURL *)linkURL
                               linkColor:(NSColor *)linkColor
{
    // get substring
    NSString *sourceString = self.string;
    NSRange linkrange = [sourceString rangeOfString:linkKey];
    if (linkrange.location == NSNotFound) {
        return self;
    }
    CGFloat linkEndLocation = linkrange.location + linkrange.length;
    
    // build the hyper link
    NSAttributedString *hyperlinkString = [linktext htf_hyperlinkToURL:linkURL linkColor:linkColor];
    
    // get link prefix and suffix strings
    NSAttributedString *linkPrefix = [self attributedSubstringFromRange:NSMakeRange(0, linkrange.location)];
    NSAttributedString *linkSuffix = [self attributedSubstringFromRange:NSMakeRange(linkEndLocation, sourceString.length - linkEndLocation)];
    
    // build new attributed string containg the hyperlink
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:linkPrefix];
    [attrString appendAttributedString:hyperlinkString];
    [attrString appendAttributedString:linkSuffix];
    
    return attrString;
}
@end
