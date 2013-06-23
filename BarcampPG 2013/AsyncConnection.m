//
//  Created by Daddycat on 11/9/11.
//  Copyright (c) 2011 WSATP. All rights reserved.
//

#import "AsyncConnection.h"

@implementation AsyncConnection
@synthesize data = _data;
@synthesize conn = _conn;
@synthesize sender = _sender;
@synthesize identifier = _identifier;
@synthesize url = _url;
@synthesize integer1, string2;


// Sends an asynchronous HTTP POST request
- (AsyncConnection *)startDownloadWithURLString:(NSString*)url identifier:(NSString *)identifier sender:(id)sender
{
   
    _identifier = identifier;
    _sender = sender;
    _url = url;
    
    _data = [[NSMutableData alloc] init];    
    
    // which one is beter?
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];

    _conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; // release later
    
    usingBlocks = NO;
    
    return self;
}

- (AsyncConnection *)startDownloadWithURLString:(NSString *)url complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock
{
    _complete = (__bridge void (^)(__strong id))Block_copy((__bridge void*) completeBlock);
    _failed = (__bridge void (^)(__strong id))Block_copy((__bridge void*) failedBlock);
    _finished = nil;
    
    _url = url;
    
    _data = [[NSMutableData alloc] init];
    
    // which one is beter?
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"%@", url);
    
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    _conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; // release later
    
    usingBlocks = YES;
    
    return self;
}

- (AsyncConnection *)startPostJSONWithURL:(NSString *)url params:(NSDictionary *)params complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock
{
    _complete = (__bridge void (^)(__strong id))Block_copy((__bridge void*) completeBlock);
    _failed = (__bridge void (^)(__strong id))Block_copy((__bridge void*) failedBlock);
    _finished = nil;
    
    _url = url;
    
    _data = [[NSMutableData alloc] init];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if (! jsonData) {
        assert(@"jsonData failed");
//        (@"Got an error: %@", error);
    }
    
#ifdef DEBUG
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
#endif
    
    // which one is beter?
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = jsonData;

    _conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; // release later
    
    usingBlocks = YES;
    
    return self;
}


- (AsyncConnection *)startPostJSONWithURL:(NSString *)url params:(NSDictionary *)params complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock finished:(void (^)(AsyncConnection *conn))finishedBlock
{
    _complete = (__bridge void (^)(__strong id))Block_copy((__bridge void*) completeBlock);
    _failed = (__bridge void (^)(__strong id))Block_copy((__bridge void*) failedBlock);
    _finished = (__bridge void (^)(__strong id))Block_copy((__bridge void*) finishedBlock);
    
    _url = url;
    
    _data = [[NSMutableData alloc] init];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if (! jsonData) {
        assert(@"jsonData failed");
        //        (@"Got an error: %@", error);
    }
    
#ifdef DEBUG
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
#endif
    
    // which one is beter?
    //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = jsonData;
    
    _conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self]; // release later
    
    usingBlocks = YES;
    
    return self;
}

                    
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication]  setNetworkActivityIndicatorVisible:YES];
    [_data setLength:0];
}

// Called when data has been received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.json = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];

    if (usingBlocks)
    {
        if (_complete) _complete(self);
        if (_finished) _finished(self);
        Block_release((__bridge void *)_complete);
        Block_release((__bridge void *)_failed);
        Block_release((__bridge void *)_finished);
        _complete = nil;
        _failed = nil;
        _finished = nil;
    }
    else
    {
        [_sender didFinishLoading:self];
    }
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (usingBlocks)
    {
        if (_failed) _failed(self);
        if (_finished) _finished(self);
        Block_release((__bridge void *)_complete);
        Block_release((__bridge void *)_failed);
        Block_release((__bridge void *)_finished);
        _complete = nil;
        _failed = nil;
        _finished = nil;
    }
    else
    {
        [_sender didFailedLoading:self];
    }
}


@end
