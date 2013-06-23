//
//  IBFunctions.h
//  InnerBand
//
//  Created by John Blanco on 11/15/11.
//  Copyright (c) 2011 Rapture In Venice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreMotion/CoreMotion.h>

// TYPES

NSNumber *IB_BOX_BOOL(BOOL x);
NSNumber *IB_BOX_INT(NSInteger x);
NSNumber *IB_BOX_SHORT(short x);
NSNumber *IB_BOX_LONG(long x);
NSNumber *IB_BOX_UINT(NSUInteger x);
NSNumber *IB_BOX_FLOAT(float x);
NSNumber *IB_BOX_DOUBLE(double x);

BOOL IB_UNBOX_BOOL(NSNumber *x);
NSInteger IB_UNBOX_INT(NSNumber *x);
short IB_UNBOX_SHORT(NSNumber *x);
long IB_UNBOX_LONG(NSNumber *x);
NSUInteger IB_UNBOX_UINT(NSNumber *x);
float IB_UNBOX_FLOAT(NSNumber *x);
double IB_UNBOX_DOUBLE(NSNumber *x);

// STRINGIFY

NSString *IB_STRINGIFY_BOOL(BOOL x);
NSString *IB_STRINGIFY_INT(NSInteger x);
NSString *IB_STRINGIFY_SHORT(short x);
NSString *IB_STRINGIFY_LONG(long x);
NSString *IB_STRINGIFY_UINT(NSUInteger x);
NSString *IB_STRINGIFY_FLOAT(float x);
NSString *IB_STRINGIFY_DOUBLE(double x);

// BOUNDS

CGRect IB_RECT_WITH_X(CGRect rect, float x);
CGRect IB_RECT_OFFSET_X(CGRect rect, float deltaX);
CGRect IB_RECT_WITH_Y(CGRect rect, float y);
CGRect IB_RECT_OFFSET_Y(CGRect rect, float deltaY);
CGRect IB_RECT_WITH_X_Y(CGRect rect, float x, float y);

CGRect IB_RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height);
CGRect IB_RECT_WITH_WIDTH(CGRect rect, float width);
CGRect IB_RECT_WITH_WIDTH_FROM_RIGHT(CGRect rect, float width);
CGRect IB_RECT_WITH_HEIGHT(CGRect rect, float height);
CGRect IB_RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height);

CGRect IB_RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom);
CGRect IB_RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom);
CGRect IB_RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right);

CGRect IB_RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset);
CGRect IB_RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset);

// IMAGES

UIImage *IB_IMAGE(NSString *name);
NSURL *IB_URL(NSString *urlString);

// MATH

double IB_DEG_TO_RAD(double degrees);
double IB_RAD_TO_DEG(double radians);

NSInteger IB_CONSTRAINED_INT_VALUE(NSInteger val, NSInteger min, NSInteger max);
float IB_CONSTRAINED_FLOAT_VALUE(float val, float min, float max);
double IB_CONSTRAINED_DOUBLE_VALUE(double val, double min, double max);

// STRINGS

BOOL IB_IS_EMPTY_STRING(NSString *str);
BOOL IB_IS_POPULATED_STRING(NSString *str);
NSString *IB_EMPTY_STRING_IF_NIL(NSString *str);

// COLORS

float IB_RGB256_TO_COL(NSInteger rgb);
NSInteger IB_COL_TO_RGB256(float col);

// DIRECTORIES

NSString *IB_DOCUMENTS_DIR(void);
NSString *IB_CACHES_DIR(void);

// HARDWARE/DEVICE CAPABILITY

BOOL IB_IS_IPAD(void);
BOOL IB_IS_IPHONE(void);

BOOL IB_IS_MULTITASKING_AVAILABLE(void);
BOOL IB_IS_CAMERA_AVAILABLE(void);
BOOL IB_IS_GAME_CENTER_AVAILABLE(void);
BOOL IB_IS_EMAIL_ACCOUNT_AVAILABLE(void);
BOOL IB_IS_GPS_ENABLED(void);
BOOL IB_IS_GPS_ENABLED_ON_DEVICE(void);
BOOL IB_IS_GPS_ENABLED_FOR_APP(void);

// DISPATCHERS

void IB_DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)());
void IB_DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void IB_DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)());
void IB_DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)());

// localization
NSString *L(NSString *key);
