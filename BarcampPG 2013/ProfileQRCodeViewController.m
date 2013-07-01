//
//  ProfileQRCodeViewController.m
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "ProfileQRCodeViewController.h"
#import "ZXingObjC.h"

@interface ProfileQRCodeViewController ()

@end

@implementation ProfileQRCodeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] init];
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_profile_down"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_profile"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultProfileQRCode])
    {
        [Utility prompt:@"Welcome!" message:@"Please update your profile"];   
        [self performSegueWithIdentifier:@"segueUpdateProfile" sender:self];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] trackView:@"Profile"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.qrcode.image = nil;
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultProfileQRCode];
    if (!data || [data isEqualToString:@""])
    {
        return;
    }
    
    ZXMultiFormatWriter* writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix* result = [writer encode:data format:kBarcodeFormatQRCode width:self.qrcode.frame.size.width height:self.qrcode.frame.size.width error:nil];
    if (result) {
        self.qrcode.image = [UIImage imageWithCGImage:[ZXImage imageWithMatrix:result].cgimage];
    } 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setQrcode:nil];
    [super viewDidUnload];
}

- (IBAction)updateProfile:(id)sender {
    [self performSegueWithIdentifier:@"segueUpdateProfile" sender:sender];
}
@end
