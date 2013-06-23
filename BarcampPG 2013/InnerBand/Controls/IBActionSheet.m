//
//  IBActionSheet.m
//  InnerBand
//
//  Created by John Blanco on 12/1/12.
//
//

#import "IBActionSheet.h"

@implementation IBActionSheet

- (id)initWithTitle:(NSString *)title cancelBlock:(void (^)(void))cancelBlock actionBlock:(void (^)(NSInteger))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if ((self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil])) {
        if (destructiveButtonTitle) {
            [self addButtonWithTitle:destructiveButtonTitle];
            self.destructiveButtonIndex = 0;
        }

        [self addButtonWithTitle:otherButtonTitles];

        va_list args;
        va_start(args, otherButtonTitles);

        NSString * title = nil;
        while ((title = va_arg(args, NSString *))) {
            [self addButtonWithTitle:title];
        }

        if (cancelButtonTitle) {
            [self addButtonWithTitle:cancelButtonTitle];
            self.cancelButtonIndex = (self.numberOfButtons - 1);
        }

        va_end(args);

        actionBlock_ = [actionBlock copy];
        cancelBlock_ = [cancelBlock copy];
    }
    
    return self;
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.cancelButtonIndex) {
        if (cancelBlock_) {
            cancelBlock_();
        }
    } else {
        if (actionBlock_) {
            actionBlock_(buttonIndex);
        }
    }
}

@end
