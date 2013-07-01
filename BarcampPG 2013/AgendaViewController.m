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


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] init];
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_agenda_down"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_agenda"]];
        
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
    [[[GAI sharedInstance] defaultTracker] trackView:@"Agenda"];

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
