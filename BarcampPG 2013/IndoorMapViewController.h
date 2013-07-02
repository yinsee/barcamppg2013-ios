//
//  IndoorMapViewController.h
//  BarCampPenang
//
//  Created by Daddycat on 7/2/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndoorMapViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)pop:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
