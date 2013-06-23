//
//  IBCoreTextLabel.m
//  InnerBandCatalog
//
//  Created by John Blanco on 9/3/10.
//  Copyright 2010 Effective UI. All rights reserved.
//

#import "IBCoreTextLabel.h"
#import <CoreText/CoreText.h>
#import "IBFunctions.h"
#import "UIColor+InnerBand.h"

@interface IBCoreTextLabel (PRIVATE)

- (NSString *)catalogTagsInText;
- (NSMutableAttributedString *)createAttributesStringFromCatalog:(NSString *)str;
- (NSMutableAttributedString *)createMutableAttributedStringFromText;

@end

@implementation IBCoreTextLabel

@synthesize text;
@synthesize textColor;
@synthesize font;
@synthesize measuredHeight = measuredHeight_;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_boldRanges = [[NSMutableArray alloc] init];
		_italicRanges = [[NSMutableArray alloc] init];
		_underlineRanges = [[NSMutableArray alloc] init];
		_fontRanges = [[NSMutableArray alloc] init];
		
		self.textColor = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		_boldRanges = [[NSMutableArray alloc] init];
		_italicRanges = [[NSMutableArray alloc] init];
		_underlineRanges = [[NSMutableArray alloc] init];
		_fontRanges = [[NSMutableArray alloc] init];
		
		self.textColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)calculateHeightForAttributedString {
    CGFloat H = 0;
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFMutableAttributedStringRef) _attrStr);
    
    CGRect box = CGRectMake(0,0, self.bounds.size.width, CGFLOAT_MAX);
    
    CFIndex startIndex = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    // Start the next frame at the first character not visible in this frame.
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat h, ascent, descent, leading;
    
    for (j=0; j < lineCount; j++) {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        h = ascent + descent + leading;
        
        H+=h;
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    measuredHeight_ = H;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// bounds
	UIBezierPath *textPath = [UIBezierPath bezierPathWithRect:self.bounds];
	
	// clear
	[textColor setStroke];
	[self.backgroundColor setFill];
	CGContextFillRect(ctx, self.bounds);	
    
	if (_attrStr) {
		// create the frame
		CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attrStr);
		CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath.CGPath, NULL);
        
		if (frame) {
			// flip text rightways up
			CGContextTranslateCTM(ctx, 0, textPath.bounds.origin.y);
			CGContextScaleCTM(ctx, 1, -1);
			CGContextTranslateCTM(ctx, 0, -(textPath.bounds.origin.y + textPath.bounds.size.height));
            
			CTFrameDraw(frame, ctx);
			CFRelease(frame);
		}
	}
}


- (void)setBackgroundColor:(UIColor *)value {
    [super setBackgroundColor:value];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)value {
    if (value != _textColor) {
        _textColor = value;
    }
    
	if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];

        _attrStr = attrStr;
	}
	
	[self setNeedsDisplay];
}

- (void)setFont:(UIFont *)aFont {
    font = aFont;
    
    if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];
        _attrStr = attrStr;
	}
    
    [self calculateHeightForAttributedString];
}

- (void)setText:(NSString *)value {
    if (_text != value) {
        _text = value;
    }
    
	[_boldRanges removeAllObjects];
	[_italicRanges removeAllObjects];
	[_underlineRanges removeAllObjects];
	[_fontRanges removeAllObjects];
	
	if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];
        _attrStr = attrStr;
	}
    
    [self calculateHeightForAttributedString];
	[self setNeedsDisplay];
}

- (NSMutableAttributedString *)createMutableAttributedStringFromText {
	NSString *str = [self catalogTagsInText];
	return [self createAttributesStringFromCatalog:str];
}

- (NSString *)catalogTagsInText {
	NSScanner *scanner = [NSScanner scannerWithString:_text];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *scannedStr = [NSMutableString string];		
	NSString *scanStr = nil;
	NSInteger scanIndex = -1;
	NSInteger medicalLoss = 0;
	
	while ([scanner  scanUpToString:@"<" intoString:&scanStr] || [scanner scanString:@"<" intoString:nil]) {
        if (IB_IS_EMPTY_STRING(scanStr)) {
            scanner.scanLocation = scanner.scanLocation - 1;
        } else {
            [scannedStr appendString:scanStr];            
        }

        scanIndex = [scanner scanLocation];

		if ([scanner scanString:@"<b>" intoString:nil]) {
			// bold
			[scanner scanUpToString:@"</b>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_boldRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</b>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<i>" intoString:nil]) {
			// italic
			[scanner scanUpToString:@"</i>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_italicRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</i>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<u>" intoString:nil]) {
			// underline
			[scanner scanUpToString:@"</u>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_underlineRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</u>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<font " intoString:nil]) {
			[scanner scanUpToString:@">" intoString:&scanStr];
            NSString *fontName = [scanStr copy];
			[scanner scanString:@">" intoString:nil];
			
			// font
			[scanner scanUpToString:@"</font>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_fontRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
			[_fontRanges addObject:fontName];
			
			[scanner scanString:@"</font>" intoString:nil];
			medicalLoss += 14 + fontName.length;
		}
	}
	
	return scannedStr;
}

- (NSMutableAttributedString *)createAttributesStringFromCatalog:(NSString *)str {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
	
	[attrString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)_textColor.CGColor range:NSMakeRange(0, str.length)];
    
	
    if (font) {
        CTFontRef globalFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
        [attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)globalFont range:NSMakeRange(0, str.length)];
        CFRelease(globalFont);
    }
    
	for (NSValue *iValue in _boldRanges) {
		[attrString addAttribute:(NSString *)(kCTStrokeWidthAttributeName) value:IB_BOX_FLOAT(-3.0) range:iValue.rangeValue];
	}
    
	for (NSValue *iValue in _italicRanges) {
		CTFontRef iFont = CTFontCreateWithName((__bridge CFStringRef)([UIFont italicSystemFontOfSize:font.pointSize].fontName), font.pointSize, nil);
		[attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)iFont range:iValue.rangeValue];
        CFRelease(iFont);
	}
    
    for (NSValue *iValue in _underlineRanges) {
		[attrString addAttribute:(NSString *)(kCTUnderlineStyleAttributeName) value:IB_BOX_FLOAT(1.0) range:iValue.rangeValue];
	}
    
	for (NSInteger i=0; i < _fontRanges.count; i += 2) {
		NSValue *iValue = (NSValue *)[_fontRanges objectAtIndex:i];
		NSString *iFontPieces = (NSString *)[_fontRanges objectAtIndex:i+1];
        NSString *iFontName = font.fontName;
        NSInteger iFontSize = font.pointSize;

        NSArray *pieces = [iFontPieces componentsSeparatedByString:@","];
        
        if (pieces.count > 0) {
            iFontName = [pieces objectAtIndex:0];
            
            if (IB_IS_EMPTY_STRING(iFontName)) {
                if (font) {
                    iFontName = font.fontName;    
                } else {
                    iFontName = @"Helvetica";
                }
            }
        }
        
        if (pieces.count > 1) {
            NSString *strFontSize = [pieces objectAtIndex:1];
            
            if (!IB_IS_EMPTY_STRING(strFontSize)) {
                iFontSize = [strFontSize intValue];
            }
        }

        if (pieces.count > 2) {
            NSString *strFontColor = [pieces objectAtIndex:2];
            
            if (!IB_IS_EMPTY_STRING(strFontColor)) {
                UIColor *iFontColor = [UIColor colorWithHexString:strFontColor];
                [attrString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)iFontColor.CGColor range:iValue.rangeValue];
            }
        }

		CTFontRef iFont = CTFontCreateWithName((__bridge CFStringRef)iFontName, iFontSize, nil);
		[attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)iFont range:iValue.rangeValue];
        CFRelease(iFont);
	}
	
	return attrString;
}


@end
