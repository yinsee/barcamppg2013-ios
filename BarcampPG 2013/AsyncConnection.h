//
//  Created by Daddycat on 11/9/11.
//  Copyright (c) 2011 WSATP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsyncConnectionDelegate <NSObject>
- (void) didFinishLoading:(id)returnObject; 
- (void) didFailedLoading:(id)returnObject; 
@end

@interface AsyncConnection : NSObject
{
    void (^_failed) (id);
    void (^_complete) (id);
    void (^_finished) (id);
    BOOL usingBlocks;
}
// store download data
@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSURLConnection* conn;
@property (strong, nonatomic) id json;

// store download info
@property (strong, nonatomic) id<AsyncConnectionDelegate> sender;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *url;

// 2 extra storage
@property  NSInteger integer1;
@property (strong, nonatomic) NSString *string2;

// holder for any useful object
@property id obj;

- (AsyncConnection *)startDownloadWithURLString:(NSString*)url identifier:(NSString *)identifier sender:(id)sender;
- (AsyncConnection *)startDownloadWithURLString:(NSString*)url complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock;
- (AsyncConnection *)startPostJSONWithURL:(NSString *)url params:(NSDictionary *)params complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock;
- (AsyncConnection *)startPostJSONWithURL:(NSString *)url params:(NSDictionary *)params complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock finished:(void (^)(AsyncConnection *conn))finishedBlock;
- (AsyncConnection *)startPostWithURL:(NSString *)url data:(NSData *)data complete:(void (^)(AsyncConnection *conn))completeBlock failed:(void (^)(AsyncConnection *conn))failedBlock finished:(void (^)(AsyncConnection *conn))finishedBlock;
@end
