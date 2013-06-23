//
//  NSString+Encoding.m
//  InnerBand
//
//  Created by John Blanco on 3/22/12.
//  Copyright (c) 2012 Rapture In Venice. All rights reserved.
//

#import "NSString+Encoding.h"

static NSString *entityList[] = {
    @"&quot;",
    @"&amp;",
    @"&apos;",
    @"&lt;",
    @"&gt;",
};

IBXMLCharMode XMLModeForUnichar(UniChar c);
static NSString *AutoreleasedCloneForXML(NSString *src, BOOL escaping);

IBXMLCharMode XMLModeForUnichar(UniChar c) {
    // Per XML spec Section 2.2 Characters
    //   ( http://www.w3.org/TR/REC-xml/#charsets )
    if (c <= 0xd7ff)  {
        if (c >= 0x20) {
            switch (c) {
                case 34:
                    return kGTMXMLCharModeEncodeQUOT;
                case 38:
                    return kGTMXMLCharModeEncodeAMP;
                case 39:
                    return kGTMXMLCharModeEncodeAPOS;
                case 60:
                    return kGTMXMLCharModeEncodeLT;
                case 62:
                    return kGTMXMLCharModeEncodeGT;
                default:
                    return kGTMXMLCharModeValid;
            }
        } else {
            if (c == '\n')
                return kGTMXMLCharModeValid;
            if (c == '\r')
                return kGTMXMLCharModeValid;
            if (c == '\t')
                return kGTMXMLCharModeValid;
            return kGTMXMLCharModeInvalid;
        }
    }
    
    if (c < 0xE000)
        return kGTMXMLCharModeInvalid;
    
    if (c <= 0xFFFD)
        return kGTMXMLCharModeValid;
    
    return kGTMXMLCharModeInvalid;
}

static NSString *AutoreleasedCloneForXML(NSString *src, BOOL escaping) {
    NSUInteger length = [src length];

    if (!length) {
        return src;
    }
    
    NSMutableString *finalString = [NSMutableString string];
    
    // this block is common between GTMNSString+HTML and GTMNSString+XML but
    // it's so short that it isn't really worth trying to share.
    const UniChar *buffer = CFStringGetCharactersPtr((__bridge CFStringRef)src);

    if (!buffer) {
        // We want this buffer to be autoreleased.
        NSMutableData *data = [NSMutableData dataWithLength:length * sizeof(UniChar)];
        if (!data) {
            return nil;
        }
        [src getCharacters:[data mutableBytes]];
        buffer = [data bytes];
    }
    
    const UniChar *goodRun = buffer;
    NSUInteger goodRunLength = 0;
    
    for (NSUInteger i = 0; i < length; ++i) {
        
        IBXMLCharMode cMode = XMLModeForUnichar(buffer[i]);
        
        // valid chars go as is, and if we aren't doing entities, then
        // everything goes as is.
        if ((cMode == kGTMXMLCharModeValid) ||
            (!escaping && (cMode != kGTMXMLCharModeInvalid))) {
            // goes as is
            goodRunLength += 1;
        } else {
            // it's something we have to encode or something invalid
            
            // start by adding what we already collected (if anything)
            if (goodRunLength) {
                CFStringAppendCharacters((__bridge CFMutableStringRef)finalString, 
                                         goodRun, 
                                         goodRunLength);
                goodRunLength = 0;
            }
            
            // if it wasn't invalid, add the encoded version
            if (cMode != kGTMXMLCharModeInvalid) {
                // add this encoded
                [finalString appendString:entityList[cMode]];
            }
            
            // update goodRun to point to the next UniChar
            goodRun = buffer + i + 1;
        }
    }
    
    // anything left to add?
    if (goodRunLength) {
        CFStringAppendCharacters((__bridge CFMutableStringRef)finalString, 
                                 goodRun, 
                                 goodRunLength);
    }
    return finalString;
}

@implementation NSString (Encoding)

- (NSString *)stringWithURLEncodingUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)stringWithXMLSanitizingAndEscaping {
    return AutoreleasedCloneForXML(self, YES);
}

- (NSString *)stringWithXMLSanitizing {
    return AutoreleasedCloneForXML(self, NO);
}

@end
