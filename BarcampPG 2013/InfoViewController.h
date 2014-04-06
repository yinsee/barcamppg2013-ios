//
//  InfoViewController.h
//  BarCampPenang
//
//  Created by Lee Ter Yi on 6/26/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import <MapKit/MapKit.h>

@interface InfoViewController : GAITrackedViewController <MKMapViewDelegate, UIWebViewDelegate, UIScrollViewDelegate>


- (IBAction)reload:(id)sender;
- (IBAction)resume:(id)sender;
- (IBAction)tapDetected:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblDays;
@property (strong, nonatomic) IBOutlet UILabel *lblHours;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIImageView *header;

@end
