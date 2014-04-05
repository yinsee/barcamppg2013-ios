//
//  Friend.h
//  BarCampPenang
//
//  Created by Daddycat on 4/6/14.
//  Copyright (c) 2014 chimou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fbuid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSData * businesscard;

@end
