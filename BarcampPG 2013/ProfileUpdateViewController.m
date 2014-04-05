//
//  ProfileUpdateViewController.m
//  BarcampPG 2013
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "ProfileUpdateViewController.h"

@interface ProfileUpdateViewController ()
{
    UIImagePickerController *picker;
}
@end

@implementation ProfileUpdateViewController

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
    NSDictionary *profile = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultProfile];
    
    self.screenName = @"Update Profile";
    
    self.txtName.text = [profile valueForKey:@"name"];
    if (!self.txtName.text) self.txtName.text = @"";
    self.txtEmail.text = [profile valueForKey:@"email"];
    if (!self.txtEmail.text) self.txtEmail.text = @"";
    self.txtPhone.text = [profile valueForKey:@"phone"];
    if (!self.txtPhone.text) self.txtPhone.text = @"";
    self.txtProfession.text = [profile valueForKey:@"profession"];
    if (!self.txtProfession.text) self.txtProfession.text = @"";
    self.fbuid.text = [profile valueForKey:@"fbuid"];
    if (!self.fbuid.text) self.fbuid.text = @"";
    
    [self.businessCard setImage:[UIImage imageWithContentsOfFile:[Utility pathForFile:@"businesscard.jpg"]]];
    
    
    if ([profile valueForKey:@"fbuid"])
    {
        [self.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURLFacebookPicture, [profile valueForKey:@"fbuid"]]]  placeholderImage:[UIImage imageNamed:@"profile_placeholder.png"] options:SDWebImageRefreshCached];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setContentSize:CGSizeMake(320, 780)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProfile:(id)sender {
    
    if([self.txtName.text isEqualToString:@""]||[self.txtEmail.text isEqualToString:@""]||[self.txtPhone.text isEqualToString:@""]||[self.txtProfession.text isEqualToString:@""]){
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to fill up all information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        return;
    }

    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
    
    [profile setValue:self.txtName.text forKey:@"name"];
    [profile setValue:self.txtEmail.text forKey:@"email"];
    [profile setValue:self.txtPhone.text forKey:@"phone"];
    [profile setValue:self.txtProfession.text forKey:@"profession"];
    [profile setValue:self.fbuid.text forKey:@"fbuid"];
    
    [[NSUserDefaults standardUserDefaults] setObject:profile forKey:kUserDefaultProfile];

    NSString *qrcode = [[NSArray arrayWithObjects:self.txtName.text, self.txtEmail.text, self.txtPhone.text, self.txtProfession.text, self.fbuid.text, nil] componentsJoinedByString:kQRCodeDelimiter];
    [[NSUserDefaults standardUserDefaults] setObject:qrcode forKey:kUserDefaultProfileQRCode];

//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Profile" withAction:@"Update" withLabel:@"" withValue:nil];
    
    // upload
    NSData *data = [NSData dataWithContentsOfFile:[Utility pathForFile:@"businesscard.jpg"]];
    NSString *url = [NSString stringWithFormat:kURLBusinessCardUpdate, [self.txtEmail.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [ProgressHUD show:@"Uploading Card" Interaction:NO];
    [[AsyncConnection alloc] startPostWithURL:url data:data complete:^(AsyncConnection *conn) {
        //
        [[iToast makeText:@"Upload done"] show];
        [[self navigationController] popViewControllerAnimated:YES];
    } failed:^(AsyncConnection *conn) {
        //
        [[iToast makeText:@"Upload failed, please try again"] show];
    } finished:^(AsyncConnection *conn) {
        //
        [ProgressHUD dismiss];
    }];
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtEmail:nil];
    [self setTxtPhone:nil];
    [self setTxtProfession:nil];
    [self setFbuid:nil];
    [self setPhoto:nil];
    [super viewDidUnload];
}

#pragma mark -- facebook
-(void)getFBuserid
{
    
    [ProgressHUD show:@"Updating" Interaction:NO];
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         
         [ProgressHUD dismiss];
         
         if (!error) {
             self.fbuid.text = user.id;
             self.txtName.text = user.name;
             self.txtEmail.text = user[@"email"];
             if (user[@"work"])
             {
                 FBGraphObject *work = user[@"work"][0];
                 if (work)
                 {
                     self.txtProfession.text = work[@"position"][@"name"];
                     if (work[@"employer"])
                     {
                         self.txtProfession.text = [self.txtProfession.text stringByAppendingString:[NSString stringWithFormat:@" at %@", work[@"employer"][@"name"]]];
                     }
                 }
             }
             [self.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURLFacebookPicture, self.fbuid.text]]  placeholderImage:[UIImage imageNamed:@"profile_placeholder.png"] options:SDWebImageRefreshCached];
         }
         else {
             [Utility prompt:@"FBGraph Error" message:error.localizedDescription];
         }
     }];
}

- (void)publishStory
{
    // only publish once in a lifetime
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"story.published"]) return;

    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:@{@"message":@"I am at BarCampPenang!", @"link":@"http://barcamppenang.org/"}
     HTTPMethod:@"POST" completionHandler:nil];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"published" forKey:@"story.published"];
}

-(void)updateAndPublish
{
//    [[[GAI sharedInstance] defaultTracker] trackEventWithCategory:@"Profile" withAction:@"Link Facebook" withLabel:@"" withValue:nil];

    [self getFBuserid];
    [self publishStory];
    
}

- (void)openSessionForReadPermissions
{
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email"] allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
        
        //this is called even from the reauthorizeWithPublishPermissions
        if (state == FBSessionStateOpen && !error)
        {
            // make sure we can publish
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"]==NSNotFound)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openSessionForPublishPermissions];
                });
            }
            else
            {
                [self updateAndPublish];
            }
        }
        else if (state==FBSessionStateClosed || state==FBSessionStateClosedLoginFailed)
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (error) {
                [Utility prompt:@"FB Error" message:error.localizedDescription];
            }
        }
    }];
}

-(void)openSessionForPublishPermissions
{
    [FBSession.activeSession
     reauthorizeWithPublishPermissions:@[@"publish_actions"]
     defaultAudience:FBSessionDefaultAudienceFriends completionHandler:
     ^(FBSession *session, NSError *error)
     {
         if (!error)
         {
             [self updateAndPublish];
         }
         else
         {
             [Utility prompt:@"FB Error" message:error.localizedDescription];
         }
     }];
}

- (IBAction)linkFacebook:(id)sender {
        
    if (!FBSession.activeSession.isOpen)
        [self openSessionForReadPermissions];
    else if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"]==NSNotFound)
    {
        // if we do not have publish permissions,
        // remove the flag so we can repost. 
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"story.published"];
        [self openSessionForPublishPermissions];
    }
    else
        [self updateAndPublish];
}

- (IBAction)pop:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)updateBusinessCard:(id)sender {
    [UIActionSheet showInView:self.view withTitle:@"Business Card" cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@[@"Camera", @"Photos"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {

        if (buttonIndex==actionSheet.cancelButtonIndex || buttonIndex < 1) return; // cancel button
        
        
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
    UIImage *result = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.businessCard setImage:result];
    
    NSData *data = UIImageJPEGRepresentation(result, 90);
    [data writeToFile:[Utility pathForFile:@"businesscard.jpg"] atomically:YES];

    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerx
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}
@end
