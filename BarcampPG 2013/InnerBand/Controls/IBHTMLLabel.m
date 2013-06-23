//
//  IBHTMLLabel.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IBHTMLLabel.h"
#import "UIColor+InnerBand.h"

@interface IBHTMLLabel (PRIVATE)

- (void)calculateHTML;

@end

@implementation IBHTMLLabel

@synthesize text = _text;
@synthesize textAlignment = _textAlignment;
@synthesize textColor = _textColor;
@synthesize linkColor = _linkColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.textColor = [UIColor blackColor];
		self.linkColor = [UIColor blueColor];
        #ifdef __IPHONE_6_0
            self.textAlignment = NSTextAlignmentLeft;
        #else
            self.textAlignment = UITextAlignmentLeft;
        #endif
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.textColor = [UIColor blackColor];
		self.linkColor = [UIColor blueColor];
        #ifdef __IPHONE_6_0
            self.textAlignment = NSTextAlignmentLeft;
        #else
            self.textAlignment = UITextAlignmentLeft;
        #endif
    }

    return self;
}

#pragma mark -

- (void)setText:(NSString *)value {
	_text = [value copy];
	[self calculateHTML];
}

- (void)setTextAlignment:(UITextAlignment)value {
	_textAlignment = value;
	[self calculateHTML];
}

- (void)setTextColor:(UIColor *)value {
    if (_textColor != value) {
        _textColor = value;
    }
    
	[self calculateHTML];
}

- (void)setLinkColor:(UIColor *)value {
    if (_linkColor != value) {
        _linkColor = value;
    }

	[self calculateHTML];
}

- (void)calculateHTML {
	NSString *htmlText = (_text) ? _text : @"";
	NSString *htmlAlignmentValue = nil;
	
	switch (_textAlignment) {
        #ifdef __IPHONE_6_0
            case NSTextAlignmentRight:
                htmlAlignmentValue = @"right";
                break;
            case NSTextAlignmentCenter:
                htmlAlignmentValue = @"center";
                break;
        #else
            case UITextAlignmentRight:
                htmlAlignmentValue = @"right";
                break;
            case UITextAlignmentCenter:
                htmlAlignmentValue = @"center";
                break;
        #endif
		default:
			htmlAlignmentValue = @"left";
			break;
	}
	
	if (_textColor) {
		htmlText = [NSString stringWithFormat:@"<span style=\"color:%@;\">%@</span>", [_textColor hexString], htmlText];
	}

	if (htmlAlignmentValue) {
		htmlText = [NSString stringWithFormat:@"<div align=\"%@\">%@</div>", htmlAlignmentValue, htmlText];
	}

	if (_linkColor) {
		htmlText = [NSString stringWithFormat:@"<style type=\"text/css\">a { color: %@; }</style>%@", [_linkColor hexString], htmlText];
	}
		
	[self loadHTMLString:htmlText baseURL:nil];
}

@end
