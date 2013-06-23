//
//  IBTargetAction.h
//  InnerBand
//
//  Created by John Blanco on 3/23/12.
//  Copyright (c) 2012 Rapture In Venice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBTargetAction : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *action;

@end
