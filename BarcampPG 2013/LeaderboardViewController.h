//
//  LeaderboardViewController.h
//  BarcampPenang
//
//  Created by Daddycat on 3/24/14.
//  Copyright (c) 2014 chimou. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "Utility.h"

@interface LeaderboardViewController : GAITrackedViewController
- (IBAction)reload:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)pop:(id)sender;

@end
