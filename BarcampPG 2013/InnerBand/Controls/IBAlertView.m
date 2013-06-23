//
//  IBAlertView.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IBAlertView.h"

@implementation IBAlertView

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:dismissBlock okBlock:okBlock] show];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    return [[IBAlertView alloc] initWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:dismissBlock okBlock:okBlock];
}

+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message {
    [self showDismissWithTitle:title message:message dismissBlock:nil];
}

+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message dismissBlock:(void (^)(void))dismissBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:NSLocalizedString(@"Dismiss", nil) okTitle:nil dismissBlock:dismissBlock okBlock:nil] show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:dismissTitle otherButtonTitles:okTitle, nil];
    
    if (self) {
        okCallback_ = [okBlock copy];
        dismissCallback_ = [dismissBlock copy];
    }
    
    return self;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:dismissTitle dismissBlock:dismissBlock] show];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    return [[IBAlertView alloc] initWithTitle:title message:message dismissTitle:dismissTitle dismissBlock:dismissBlock];    
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:dismissTitle otherButtonTitles:nil];
    
    if (self) {
        dismissCallback_ = [dismissBlock copy];
    }
    
    return self;
}                                                                                                                                                      

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.numberOfButtons == 2) {
        if (buttonIndex == 0) {
            if (dismissCallback_) {
                dismissCallback_();
            }
        } else {
            if (okCallback_) {
                okCallback_();
            }
        }
    } else {
        if (dismissCallback_) {
            dismissCallback_();
        }
    }
}

@end
