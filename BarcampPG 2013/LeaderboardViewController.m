//
//  LeaderboardViewController.m
//  BarcampPenang
//
//  Created by Daddycat on 3/24/14.
//  Copyright (c) 2014 chimou. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)loadFromCache
{
    NSString *html = [NSString stringWithContentsOfFile: [Utility pathForFile:@"leaderboard.html"] encoding:NSUTF8StringEncoding error:nil];
    if (!html)
    {
        html = @"Content not loaded, please try to refresh.";
    }
    [self.webview loadHTMLString:html baseURL:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // clear webview shadow
    for (UIView* shadowView in [self.webview.scrollView subviews])
    {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.screenName = @"Leaderboard";
    
    // auto reload each time view-did-appear
    static BOOL firsttime = YES;
    if (firsttime)
    {
        firsttime = NO;
        [self reload:nil];
    }
    [self loadFromCache];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reload:(id)sender {
    [[AsyncConnection alloc] startDownloadWithURLString:kURLLeaderboard complete:^(AsyncConnection *conn) {
        // write conn to cache
        [conn.data writeToFile:[Utility pathForFile:@"leaderboard.html"] atomically:YES];
        [self loadFromCache];
    } failed:^(AsyncConnection *conn) {
        //
        [self loadFromCache];
    }];
}

- (void)viewDidUnload {
    [self setWebview:nil];
    [super viewDidUnload];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
