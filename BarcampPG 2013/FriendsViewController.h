//
//  FriendsViewController.h
//  BarCampPenang
//
//  Created by Daddycat on 6/23/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface FriendsViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friends;
@end
