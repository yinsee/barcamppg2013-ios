//
//  IBFunctions.m
//  InnerBand
//
//  Created by John Blanco on 11/15/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBFunctions.h"

// TYPES

NSNumber *IB_BOX_BOOL(BOOL x) { return [NSNumber numberWithBool:x]; }
NSNumber *IB_BOX_INT(NSInteger x) { return [NSNumber numberWithInt:x]; }
NSNumber *IB_BOX_SHORT(short x) { return [NSNumber numberWithShort:x]; }
NSNumber *IB_BOX_LONG(long x) { return [NSNumber numberWithLong:x]; }
NSNumber *IB_BOX_UINT(NSUInteger x) { return [NSNumber numberWithUnsignedInt:x]; }
NSNumber *IB_BOX_FLOAT(float x) { return [NSNumber numberWithFloat:x]; }
NSNumber *IB_BOX_DOUBLE(double x) { return [NSNumber numberWithDouble:x]; }

BOOL IB_UNBOX_BOOL(NSNumber *x) { return [x boolValue]; }
NSInteger IB_UNBOX_INT(NSNumber *x) { return [x intValue]; }
short IB_UNBOX_SHORT(NSNumber *x) { return [x shortValue]; }
long IB_UNBOX_LONG(NSNumber *x) { return [x longValue]; }
NSUInteger IB_UNBOX_UINT(NSNumber *x) { return [x unsignedIntValue]; }
float IB_UNBOX_FLOAT(NSNumber *x) { return [x floatValue]; }
double IB_UNBOX_DOUBLE(NSNumber *x) { return [x doubleValue]; }

// STRINGIFY

NSString *IB_STRINGIFY_BOOL(BOOL x) { return (x ? @"true" : @"false"); }
NSString *IB_STRINGIFY_INT(NSInteger x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *IB_STRINGIFY_SHORT(short x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *IB_STRINGIFY_LONG(long x) { return [NSString stringWithFormat:@"%li", x]; }
NSString *IB_STRINGIFY_UINT(NSUInteger x) { return [NSString stringWithFormat:@"%u", x]; }
NSString *IB_STRINGIFY_FLOAT(float x) { return [NSString stringWithFormat:@"%f", x]; }
NSString *IB_STRINGIFY_DOUBLE(double x) { return [NSString stringWithFormat:@"%f", x]; }

// BOUNDS

CGRect IB_RECT_WITH_X(CGRect rect, float x) { return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height); }
CGRect IB_RECT_OFFSET_X(CGRect rect, float deltaX) { return CGRectMake(rect.origin.x + deltaX, rect.origin.y, rect.size.width, rect.size.height); }
CGRect IB_RECT_WITH_Y(CGRect rect, float y) { return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height); }
CGRect IB_RECT_OFFSET_Y(CGRect rect, float deltaY) { return CGRectMake(rect.origin.x, rect.origin.y + deltaY, rect.size.width, rect.size.height); }
CGRect IB_RECT_WITH_X_Y(CGRect rect, float x, float y) { return CGRectMake(x, y, rect.size.width, rect.size.height); }

CGRect IB_RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height) { return CGRectMake(rect.origin.x, rect.origin.y, width, height); }
CGRect IB_RECT_WITH_WIDTH(CGRect rect, float width) { return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height); }
CGRect IB_RECT_WITH_WIDTH_FROM_RIGHT(CGRect rect, float width) { return CGRectMake(rect.origin.x + rect.size.width - width, rect.origin.y, width, rect.size.height); }
CGRect IB_RECT_WITH_HEIGHT(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height); }
CGRect IB_RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - height, rect.size.width, height); }

CGRect IB_RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom) { return CGRectMake(rect.origin.x + left, rect.origin.y + top, rect.size.width - left - right, rect.size.height - top - bottom); }
CGRect IB_RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom) { return CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height - top - bottom); }
CGRect IB_RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right) { return CGRectMake(rect.origin.x + left, rect.origin.y, rect.size.width - left - right, rect.size.height); }

CGRect IB_RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset) { return CGRectMake(rect.origin.x + rect.size.width + offset, rect.origin.y, rect.size.width, rect.size.height); }
CGRect IB_RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + offset, rect.size.width, rect.size.height); }

// TRANSFORMS

UIImage *IB_IMAGE(NSString *name) { return [UIImage imageNamed:name]; }
NSURL *IB_URL(NSString *urlString) { return [NSURL URLWithString:urlString]; }

// MATH

double IB_DEG_TO_RAD(double degrees) { return degrees * M_PI / 180.0; }
double IB_RAD_TO_DEG(double radians) { return radians * 180.0 / M_PI; }

NSInteger IB_CONSTRAINED_INT_VALUE(NSInteger val, NSInteger min, NSInteger max) { return MIN(MAX(val, min), max); }
float IB_CONSTRAINED_FLOAT_VALUE(float val, float min, float max) { return MIN(MAX(val, min), max); }
double IB_CONSTRAINED_DOUBLE_VALUE(double val, double min, double max) { return MIN(MAX(val, min), max); }

// STRINGS

BOOL IB_IS_EMPTY_STRING(NSString *str) { return !str || ![str isKindOfClass:NSString.class] || [str length] == 0; }
BOOL IB_IS_POPULATED_STRING(NSString *str) { return str && [str isKindOfClass:NSString.class] && [str length] > 0; }
NSString *IB_EMPTY_STRING_IF_NIL(NSString *str) { return (str) ? str : @""; }

// COLORS

float IB_RGB256_TO_COL(NSInteger rgb) { return rgb / 255.0f; }
NSInteger IB_COL_TO_RGB256(float col) { return (NSInteger)(col * 255.0); }

// DIRECTORIES

NSString *IB_DOCUMENTS_DIR(void) { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; }
NSString *IB_CACHES_DIR(void) { return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]; }

// HARDWARE/DEVICE CAPABILITY

BOOL IB_IS_IPAD(void) {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

BOOL IB_IS_IPHONE(void) {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

BOOL IB_IS_CAMERA_AVAILABLE(void) {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

BOOL IB_IS_GAME_CENTER_AVAILABLE(void) {
    return NSClassFromString(@"GKLocalPlayer") && [[[UIDevice currentDevice] systemVersion] compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending;
}

BOOL IB_IS_EMAIL_ACCOUNT_AVAILABLE(void) {
    Class composerClass = NSClassFromString(@"MFMailComposeViewController");
    return [composerClass respondsToSelector:@selector(canSendMail)];
}

BOOL IB_IS_GPS_ENABLED(void) {
    return IB_IS_GPS_ENABLED_ON_DEVICE() && IB_IS_GPS_ENABLED_FOR_APP();
}

BOOL IB_IS_GPS_ENABLED_ON_DEVICE(void) {
    BOOL isLocationServicesEnabled;
    
    Class locationClass = NSClassFromString(@"CLLocationManager");
    NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(locationServicesEnabled)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation invoke];
    [invocation getReturnValue:&isLocationServicesEnabled];
    
    return locationClass && isLocationServicesEnabled;    
}

BOOL IB_IS_GPS_ENABLED_FOR_APP(void) {
    // for 4.2+ only, we can check down to the app level
    #ifdef kCLAuthorizationStatusAuthorized
        Class locationClass = NSClassFromString(@"CLLocationManager");
    
        if ([locationClass respondsToSelector:@selector(authorizationStatus)]) {
            NSInteger authorizationStatus;
            
            NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(authorizationStatus)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation invoke];
            [invocation getReturnValue:&authorizationStatus];
            
            return locationClass && (authorizationStatus == kCLAuthorizationStatusAuthorized);    
        }
    #endif
    
    // we can't know this
    return YES;
}

// DISPATCHERS

void IB_DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)()) {
    if (isAsync) {
        dispatch_async(dispatch_get_main_queue(), block);
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);        
    }
}

void IB_DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)()) {
    if (isAsync) {    
        dispatch_async(dispatch_get_global_queue(priority, 0), block);
    } else {
        dispatch_sync(dispatch_get_global_queue(priority, 0), block);        
    }
}

void IB_DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)()) {
    if (isAsync) {    
        dispatch_async(queue, block);
    } else {
        dispatch_sync(queue, block);
    }
}

void IB_DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, dispatch_get_main_queue(), block);
}

void IB_DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, dispatch_get_global_queue(priority, 0), block);
}

void IB_DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, queue, block);
}

NSString *L(NSString *key) {
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:nil];
}
