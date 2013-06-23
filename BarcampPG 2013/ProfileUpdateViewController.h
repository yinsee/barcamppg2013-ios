//
//  ProfileUpdateViewController.h
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "Utility.h"

@interface ProfileUpdateViewController : UIFormViewController
- (IBAction)saveProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtProfession;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *fbuid;
- (IBAction)linkFacebook:(id)sender;
-(void)updateAndPublish;
@end
