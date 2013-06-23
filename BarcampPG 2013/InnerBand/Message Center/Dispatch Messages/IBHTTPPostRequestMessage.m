//
//  IBHTTPPostRequestMessage.m
//  Broadway
//
//  Created by John Blanco on 10/7/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import "IBHTTPPostRequestMessage.h"
#import <UIKit/UIKit.h>
#import "IBMessageCenter.h"
#import "IBFunctions.h"

@implementation IBHTTPPostRequestMessage

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body {
	IBHTTPPostRequestMessage *message = [[IBHTTPPostRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
	message->_url = [url copy];
	message->_headersDict = [[NSMutableDictionary alloc] init];
	message->_body = [body copy];

	// autorelease
    return message;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body processBlock:(ib_http_proc_t)processBlock {
	IBHTTPPostRequestMessage *message = [[IBHTTPPostRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
	message->_url = [url copy];
	message->_headersDict = [[NSMutableDictionary alloc] init];
	message->_body = [body copy];
    message->_processBlock = [processBlock copy];
    
	// autorelease
    return message;
}

#pragma mark -

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key {
    [_headersDict setValue:value forKey:key];
}

- (void)inputData:(NSData *)input {
	NSString *subbedURL = _url;
	NSError *error = nil;
	NSHTTPURLResponse *response = nil;
	
	// perform substitutions on URL
	for (NSString *key in self.userInfo) {
		NSString *subToken = [NSString stringWithFormat:@"[%@]", key];
        
		if ([[self.userInfo objectForKey:key] isKindOfClass:NSString.class]) {
            subbedURL = [subbedURL stringByReplacingOccurrencesOfString:subToken withString:[(NSString *)[self.userInfo objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
	}
    
	// debug
    if ([IBMessageCenter isDebuggingEnabled]) {
        NSLog(@"OPEN URL: %@", subbedURL);
    }
	
	// generate request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:subbedURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:_headersDict];
    [request setHTTPBody:[_body dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	if (!error) {
		_responseData = [content mutableCopy];
        
		if (response) {
            [self setUserInfoValue:IB_BOX_INT(response.statusCode) forKey:HTTP_STATUS_CODE];
            
            if (_processBlock) {
                _processBlock(_responseData, response.statusCode);
            }
        } else if (_processBlock) {
            _processBlock(_responseData, 0);
        }
	} else {
		_responseData = nil;
        
        if (_processBlock) {
            _processBlock(_responseData, response ? response.statusCode : 0);
        }
	}
}

- (NSData *)outputData {
	return _responseData;
}

@end
