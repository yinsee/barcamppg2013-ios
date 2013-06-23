//
//  AgendaViewController.h
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface AgendaViewController : UIViewController
- (IBAction)reload:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
