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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
        [Utility prompt:@"Welcome!" message:@"Please update your profile"];
        
        [self performSegueWithIdentifier:@"segueUpdateProfile" sender:self];
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
