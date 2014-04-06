//
//  Utility.h
//  mBay
//
//  Created by Daddycat on 3/16/13.
//  Copyright (c) 2013 Genesis Merchant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "AppDelegate.h"
#import "UIFormViewController.h"
#import "AsyncConnection.h"
#import "ProgressHUD.h"
#import "iToast.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "GAI.h"
#import "UIActionSheet+Blocks.h"
#import <FacebookSDK/FacebookSDK.h>

#define kAppStoreURL @"https://itunes.apple.com/app/id665652007"
#define kAnalyticsID @"UA-35359053-9"
#define kAnalyticsDispatchInterval 30
#define kAppID @"665652007"

#define kBarcampDate @"20140517"

#define APN_TOKEN()    [[NSUserDefaults standardUserDefaults] objectForKey:@"APNToken"]
#if (TARGET_IPHONE_SIMULATOR1)
#define __DOMAIN__ @"http://localhost/~yinsee/"
#else
#define __DOMAIN__ @"http://barcamppenang.org/"
#endif

#define kURLAgenda __DOMAIN__ @"agenda.html"
#define kURLSponsor __DOMAIN__ @"sponsors.html"
#define kURLLeaderboard @"http://chimou.com/barcamppg/leaderboard.php"
#define kURLLeaderboardUpdate @"http://chimou.com/barcamppg/leaderboard.php?a=update"
#define kURLBusinessCard @"http://chimou.com/barcamppg/namecard.php?get&email=%@"
#define kURLBusinessCardUpdate @"http://chimou.com/barcamppg/namecard.php?email=%@"

#define kMapLocationCoordinate CLLocationCoordinate2DMake(5.339429,100.281334)
#define kMapPinTitle @"INTI Intl College Penang"
#define kMapPinSubTitle @"10 Persiaran Bukit Jambul. +604-6310138"
#define kURLFacebookPicture @"http://graph.facebook.com/%@/picture"

#define FBSessionStateChangedNotification @"FBSessionStateChangedNotification"

#define kUserDefaultProfile @"profile"
#define kUserDefaultProfileQRCode @"profile.qrcode"
#define kQRCodeDelimiter @"||"
#define kQRCodeNumberOfItems 5
#define kNotifQRCodeSuccess @"qrcode.success"


@interface Utility : NSObject
+(NSString *)udid;
+(NSString *)pathForFile:(NSString *)filename;
+(BOOL)isIPAD;
+(void)prompt:(NSString *)title message:(NSString *)message;
@end


@interface UIImage(Tools)
-(NSString *)base64;
@end

@interface NSMutableArray(Plist)
-(BOOL)writeToPlistFile:(NSString*)path;
+(NSMutableArray*)readFromPlistFile:(NSString*)path;
@end

@interface NSMutableDictionary(Plist)
-(BOOL)writeToPlistFile:(NSString*)path;
+(NSMutableDictionary*)readFromPlistFile:(NSString*)path;
@end
