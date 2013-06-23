//
//  FriendDetailViewController.h
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Friend.h"

@interface FriendDetailViewController : UIViewController
@property Friend *data;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *profession;
@property (strong, nonatomic) IBOutlet UIButton *email;
@property (strong, nonatomic) IBOutlet UIButton *phone;
@property (strong, nonatomic) IBOutlet UIButton *facebook;
- (IBAction)sendmail:(id)sender;
- (IBAction)phonecall:(id)sender;
- (IBAction)openfacebook:(id)sender;
@end
