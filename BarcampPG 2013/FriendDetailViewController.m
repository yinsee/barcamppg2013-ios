//
//  FriendDetailViewController.m
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "FriendDetailViewController.h"

@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)layoutSubviews
{
    self.title = self.name.text = self.data.name;
    self.profession.text = self.data.profession;
    [self.phone setTitle:self.data.phone forState:UIControlStateNormal];
    [self.sms setTitle:self.data.phone  forState:UIControlStateNormal];
    [self.email setTitle:self.data.email  forState:UIControlStateNormal];
    
    [self.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURLFacebookPicture, self.data.fbuid]]  placeholderImage:[UIImage imageNamed:@"profile_placeholder.png"] options:SDWebImageRefreshCached];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.screenName = @"Friend Detail";
    [self layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setProfession:nil];
    [self setEmail:nil];
    [self setPhone:nil];
    [self setFacebook:nil];
    [self setPhoto:nil];
    [self setSms:nil];
    [super viewDidUnload];
}

- (IBAction)sendmail:(id)sender
{
//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Friend" withAction:@"Open" withLabel:@"Email" withValue:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.data.email]];
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [Utility prompt:@"Can't email" message:@"Make sure your email app is setup correctly"];
}

- (IBAction)sendsms:(id)sender {
//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Friend" withAction:@"Open" withLabel:@"SMS" withValue:nil];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", self.data.phone]];
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [Utility prompt:@"Can't call" message:@"This device cannot send sms"];
}

-(void)phonecall:(id)sender
{
//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Friend" withAction:@"Open" withLabel:@"Phone" withValue:nil];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.data.phone]];
    if([[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
    else
        [Utility prompt:@"Can't call" message:@"This device cannot make phone call"];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openfacebook:(id)sender
{
    NSString *fbURL = [NSString stringWithFormat:@"fb://profile/%@", self.data.fbuid];

//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Friend" withAction:@"Open" withLabel:@"Facebook" withValue:nil];

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:fbURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbURL]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://facebook.com/%@", self.data.fbuid]]];
    }
}
@end
