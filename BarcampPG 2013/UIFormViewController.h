//
//  UIFormViewController.h
//  mBay
//
//  Created by Daddycat on 3/16/13.
//  Copyright (c) 2013 Genesis Merchant. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAI.h"

@interface UIFormViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(UIView *)firstResponder;
@end
