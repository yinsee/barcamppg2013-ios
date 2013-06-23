//
//  FriendsViewController.m
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "FriendsViewController.h"
#import "NSManagedObject+InnerBand.h"
#import "Friend.h"
#import "FriendCell.h"
#import "FriendDetailViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qrcodeSuccess:) name:kNotifQRCodeSuccess object:nil];

    [self reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] trackView:@"Friends"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.friends count]>0)
        return 72;
    else
        return 500;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.friends count]>0)
        return [self.friends count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UIImage *defaultPhoto = nil;
    
    if (!defaultPhoto) defaultPhoto = [UIImage imageNamed:@"mike.png"];
    
    if (!self.friends || [self.friends count]<1)
    {
        // show poor mike if no friend
        return [tableView dequeueReusableCellWithIdentifier:@"NoFriendCell"];
    }
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    // Configure the cell...
    Friend *row = [self.friends objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.name.text = row.name;
    cell.profession.text = row.profession;
    [cell.photo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURLFacebookPicture, row.fbuid]]  placeholderImage:defaultPhoto];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueFriendDetail"])
    {
        FriendDetailViewController *dest = segue.destinationViewController;
        [dest setData:[self.friends objectAtIndex:((UITableViewCell *)sender).tag]];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        Friend *row = [self.friends objectAtIndex:indexPath.row];
        [row destroy];
        [[IBCoreDataStore mainStore] save];
        [self.friends removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

#pragma mark - observer
-(void)reloadData
{
    self.friends = [NSMutableArray arrayWithArray:[Friend allOrderedBy:@"name" ascending:YES]];
}

-(void)qrcodeSuccess:(NSNotification *)notification
{
    NSArray *data = [notification.userInfo objectForKey:@"data"];

    // find
    Friend *f;
    // check email
    f = [Friend firstWithKey:@"email" value:[data objectAtIndex:1]];
    // check phone
    if (!f) f = [Friend firstWithKey:@"phone" value:[data objectAtIndex:2]];
    // check facebook
    if (!f) f = [Friend firstWithKey:@"fbuid" value:[data objectAtIndex:4]];
    // create new if not found
    if (!f) f = [Friend create];
    
    f.name = [data objectAtIndex:0];
    f.email = [data objectAtIndex:1];
    f.phone = [data objectAtIndex:2];
    f.profession = [data objectAtIndex:3];
    f.fbuid = [data objectAtIndex:4];
    
    
    [[IBCoreDataStore mainStore] save];
    
    [self reloadData];
    [self.tableView reloadData];
}
@end
