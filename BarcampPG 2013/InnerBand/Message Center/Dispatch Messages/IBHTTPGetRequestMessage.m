//
//  IBHTTPGetRequestMessage.m
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

#import "IBHTTPGetRequestMessage.h"
#import <UIKit/UIKit.h>
#import "IBMessageCenter.h"
#import "IBFunctions.h"

@implementation IBHTTPGetRequestMessage

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url {
	IBHTTPGetRequestMessage *message = [[IBHTTPGetRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
    message->_url = [url copy];
	message->_headersDict = [[NSMutableDictionary alloc] init];
	
	// autorelease
    return message;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url processBlock:(ib_http_proc_t)processBlock {
	IBHTTPGetRequestMessage *message = [[IBHTTPGetRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
    message->_url = [url copy];
	message->_headersDict = [[NSMutableDictionary alloc] init];
    message->_processBlock = [processBlock copy];
    
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
    [request setAllHTTPHeaderFields:_headersDict];
    
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
