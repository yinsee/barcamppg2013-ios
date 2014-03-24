//
//  ProfileQRCodeViewController.h
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface ProfileQRCodeViewController : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UIImageView *qrcode;
- (IBAction)updateProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profilephoto;

@end
