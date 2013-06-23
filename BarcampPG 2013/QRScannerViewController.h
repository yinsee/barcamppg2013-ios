//
//  QRScannerViewController.h
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "ZXingObjC.h"

@interface QRScannerViewController : UIViewController <ZXCaptureDelegate>
- (IBAction)cancel:(id)sender;

@end
