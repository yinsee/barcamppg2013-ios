//
//  ProfileImageView.m
//  BarCampPenang
//
//  Created by Daddycat on 6/28/13.
//  Copyright (c) 2013 chimou. All rights reserved.
//

#import "ProfileImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setNeedsDisplay {
    // Drawing code
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0] CGColor];
    self.layer.borderWidth = 1.0;
}


@end
