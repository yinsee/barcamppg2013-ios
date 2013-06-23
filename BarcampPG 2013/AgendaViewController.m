//
//  AgendaViewController.m
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "AgendaViewController.h"

@interface AgendaViewController ()

@end

@implementation AgendaViewController

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
    NSString *html = [NSString stringWithContentsOfFile: [Utility pathForFile:@"agenda.html"] encoding:NSUTF8StringEncoding error:nil];
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] trackView:@"Agenda"];

    // auto reload each time view-did-appear
    static BOOL firsttime = YES;
    if (firsttime)
    {
        firsttime = NO;
        [self loadFromCache];
    }
    [self reload:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reload:(id)sender {
    [[AsyncConnection alloc] startDownloadWithURLString:kURLAgenda complete:^(AsyncConnection *conn) {
        // write conn to cache
        [conn.data writeToFile:[Utility pathForFile:@"agenda.html"] atomically:YES];
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
@end
