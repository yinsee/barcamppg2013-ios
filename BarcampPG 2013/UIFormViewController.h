//
//  UIFormViewController.h
//  mBay
//
//  Created by Daddycat on 3/16/13.
//  Copyright (c) 2013 Genesis Merchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "GAITrackedViewController.h"

@interface UIFormViewController : GAITrackedViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UITapGestureRecognizer *gestureRecognizer;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(UIView *)firstResponder;
- (void)hideKeyboard;
@end
