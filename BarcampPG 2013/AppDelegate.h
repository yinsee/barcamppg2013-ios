//
//  AppDelegate.h
//  BarcampPG 2013
//
//  Created by Daddycat on 5/20/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAccelerometerDelegate>
{
    BOOL histeresisExcited;
    AVAudioPlayer *laughter; // is the best medicine
}

@property (strong, nonatomic) UIWindow *window;
@property(retain) UIAcceleration* lastAcceleration;
@end
