//
//  IndoorMapViewController.m
//  BarCampPenang
//
//  Created by Daddycat on 7/2/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "IndoorMapViewController.h"

@interface IndoorMapViewController ()

@end

@implementation IndoorMapViewController

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
//    self.mapImageView
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView==self.scrollView)
    {
        return self.mapImageView;
    }
    return nil;
}

- (void)viewDidUnload {
    [self setMapImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
