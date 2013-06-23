//
//  NSString+Encoding.h
//  InnerBand
//
//  Created by John Blanco on 3/22/12.
//  Copyright (c) 2012 Rapture In Venice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kGTMXMLCharModeEncodeQUOT  = 0,
    kGTMXMLCharModeEncodeAMP   = 1,
    kGTMXMLCharModeEncodeAPOS  = 2,
    kGTMXMLCharModeEncodeLT    = 3,
    kGTMXMLCharModeEncodeGT    = 4,
    kGTMXMLCharModeValid       = 99,
    kGTMXMLCharModeInvalid     = 100,
} IBXMLCharMode;

@interface NSString (Encoding)

- (NSString *)stringWithURLEncodingUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)stringWithXMLSanitizingAndEscaping;
- (NSString *)stringWithXMLSanitizing;

@end
