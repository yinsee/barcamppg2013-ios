//
//  InfoViewController.m
//  BarCampPenang
//
//  Created by Lee Ter Yi on 6/26/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.tabBarItem = [[UITabBarItem alloc] init];
        [[self tabBarItem] setFinishedSelectedImage:[UIImage imageNamed:@"tab_info_down"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab_info"]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.scrollView.delegate = self;
    [self.mapButton setTitle:@"" forState:UIControlStateNormal];
    
    
    // clear webview shadow
    for (UIView* shadowView in [self.webView.scrollView subviews])
    {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }

    
    // place map pin
    self.mapView.delegate = self;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = kMapLocationCoordinate;
    point.title = kMapPinTitle;
    point.subtitle = kMapPinSubTitle;
    [self.mapView addAnnotation:point];

    // center 
    [self centerMap:NO];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[[GAI sharedInstance] defaultTracker] trackView:@"Agenda"];
    
    [self updateClock];
    
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

- (void)viewDidUnload {
    [self setLblDays:nil];
    [self setLblHours:nil];
    [self setScrollView:nil];
    [self setMapView:nil];
    [self setWebView:nil];
    [self setMapButton:nil];
    [self setResumeButton:nil];
    [super viewDidUnload];
}



-(void)updateClock
{
    NSDate *date = [NSDate date];
    int secondsNow = [date timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    int secondsTarget = [[formatter dateFromString:kBarcampDate] timeIntervalSince1970];
    
    int differenceSeconds = secondsTarget - secondsNow;
    int days = (int)((double)differenceSeconds/(3600.0*24.00));
    int diffDay = differenceSeconds-(days*3600*24);
    int hours = (int)((double)diffDay/3600.00);
    
    self.lblDays.text = [NSString stringWithFormat:@"%d",days];
    self.lblHours.text = [NSString stringWithFormat:@"%d",hours];
}

#pragma mark -- map
-(void)centerMap:(BOOL)isLargeMap
{
    // focus slightly below the pin
    CLLocationCoordinate2D coordinate = kMapLocationCoordinate;
    
    if (isLargeMap)
    {
   
        // show myself and pin if possible
        if (CLLocationCoordinate2DIsValid(self.mapView.userLocation.coordinate))
        {
            MKMapPoint userPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
            MKMapPoint annotationPoint = MKMapPointForCoordinate(kMapLocationCoordinate);
            // Make map rects with 0 size
            MKMapRect userRect = MKMapRectMake(userPoint.x, userPoint.y, 0, 0);
            MKMapRect annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            // Make union of those two rects
            MKMapRect unionRect = MKMapRectUnion(userRect, annotationRect);
            // You have the smallest possible rect containing both locations
            MKMapRect unionRectThatFits = [self.mapView mapRectThatFits:unionRect];
            [self.mapView setVisibleMapRect:unionRectThatFits animated:YES];
            
            return;
        }
        else
        {
            self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
        }
    }
    else
    {
        self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
        coordinate.latitude -= 0.0035;
    }
    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}

- (IBAction)resume:(id)sender{

    // hide annotation if any
    for (id currentAnnotation in self.mapView.annotations) {
        if ([currentAnnotation isKindOfClass:[MKPointAnnotation class]]) {
            [self.mapView deselectAnnotation:currentAnnotation animated:YES];
        } 
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mapView.frame = CGRectMake(0, 0, 320, 340);

        CGRect f = self.scrollView.frame;
        f.origin.y = 0;
        self.scrollView.frame = f;
    } completion:^(BOOL finished) {
        [self.resumeButton setHidden:YES];
        [self centerMap:NO];
    }];

}

- (IBAction)tapDetected:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.mapView.frame = self.view.frame;
        
        CGRect f = self.scrollView.frame;
        f.origin.y = self.view.frame.size.height;
        self.scrollView.frame = f;
    } completion:^(BOOL finished) {
        [self.resumeButton setHidden:NO];
        [self centerMap:YES];
    }];
}


#pragma mark -- html

-(void)loadFromCache
{
    NSString *html = [NSString stringWithContentsOfFile: [Utility pathForFile:@"sponsors.html"] encoding:NSUTF8StringEncoding error:nil];
    if (!html)
    {
        html = @"Content not loaded, please try to refresh.";
    }
    [self.webView loadHTMLString:html baseURL:nil];
}

- (IBAction)reload:(id)sender {
    [[AsyncConnection alloc] startDownloadWithURLString:kURLSponsor complete:^(AsyncConnection *conn) {
        // write conn to cache
        [conn.data writeToFile:[Utility pathForFile:@"sponsors.html"] atomically:YES];
        [self loadFromCache];
    } failed:^(AsyncConnection *conn) {
        //
        [self loadFromCache];
    }];
}


#pragma mark -- webview
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    int height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] intValue];
    
    // resize frame and scroll
    CGRect f = self.webView.frame;
    f.size.height = height;
    self.webView.frame = f;
    self.scrollView.contentSize = CGSizeMake(webView.frame.size.width, webView.frame.origin.y+height);
    
}

#pragma mark -- scrollview
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
//    if (scrollView.contentOffset.y>=0)
    {
        CGRect f = CGRectMake(0, -80, 320, 480);

        f.origin.y -= scrollView.contentOffset.y/3;
        if (f.origin.y<-f.size.height) f.origin.y = 0;
        
        self.mapView.frame = f;
    }

}
@end
