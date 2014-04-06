//
//  ShareViewController.m
//  BarCampPenang
//
//  Created by Daddycat on 4/6/14.
//  Copyright (c) 2014 chimou. All rights reserved.
//

#import "ShareViewController.h"
#import "Utility.h"
#import <Social/Social.h>

@interface ShareViewController ()
{
    UIImagePickerController *picker;
    NSString *posttype;
    UIImage *postimage;
}

@end

@implementation ShareViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareFB:(id)sender {
    posttype = SLServiceTypeFacebook;
    [self prompt];
}

- (IBAction)shareTwitter:(id)sender {
    
    posttype = SLServiceTypeTwitter;
    [self prompt];
}

-(void)post {

    SLComposeViewController *c = [SLComposeViewController composeViewControllerForServiceType:posttype];
    if (!c)
    {
        [[iToast makeText:@"Please update your Facebook/Twitter login in iOS Settings."] show];
        return;
    }
    if (postimage)
    {
        [c addImage:postimage];
    }
    [c setInitialText:@"#BarCampPenang "];
    [self presentViewController:c animated:YES completion:nil];

}

- (void)prompt {
    postimage = nil;
    [UIActionSheet showInView:self.view withTitle:@"Attach Photo" cancelButtonTitle:@"No Photo" destructiveButtonTitle:nil otherButtonTitles:@[@"Camera", @"Photos"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        
        if (buttonIndex==actionSheet.cancelButtonIndex || buttonIndex < 1)
        {
            [self post];
            return;
        }
        
        
        picker = [[UIImagePickerController alloc] init];
        if (buttonIndex==1)
        {
            // camera
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            // photos
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.allowsEditing = YES;
        picker.delegate = self;
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

-(void)imagePickerController:(UIImagePickerController *)pickerx didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    postimage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    picker = nil;
     
    [self post];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerx
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}
@end
