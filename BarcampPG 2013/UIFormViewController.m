//
//  UIFormViewController.m
//  mBay
//
//  Created by Daddycat on 3/16/13.
//  Copyright (c) 2013 Genesis Merchant. All rights reserved.
//

#import "UIFormViewController.h"

@interface UIFormViewController ()

@end

@implementation UIFormViewController

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
    
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
    
    
}

-(UIView *)firstResponder
{
    for (UIView *subview in self.scrollView.subviews) {
        
        if ([subview isFirstResponder]) return subview;
        
        if (subview.subviews)
        {
            for (UIView *subsubview in subview.subviews) {
                if ([subsubview isFirstResponder])
                {
                    return subsubview;
                }
            }
        }
    }
    
    return nil;
}

- (void)hideKeyboard
{
    [[self firstResponder] resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary * info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    int tabheight;
    if (self.tabBarController)
        tabheight = self.tabBarController.tabBar.frame.size.height;
    else
        tabheight = 0;
    
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardSize.height - tabheight, 0)];
    
    if ([self firstResponder].superview!=self.scrollView) // if textfield is 2nd level
        [self.scrollView scrollRectToVisible:[self firstResponder].superview.frame animated:YES];
    else
        [self.scrollView scrollRectToVisible:[self firstResponder].frame animated:YES];
    gestureRecognizer.cancelsTouchesInView = YES;
    
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    [self.scrollView setContentInset:UIEdgeInsetsZero];
    gestureRecognizer.cancelsTouchesInView = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// you can use tag to jump
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *nextview = [self.view viewWithTag:textField.tag+1];
    if (nextview)
        [nextview becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return YES;
}

@end
