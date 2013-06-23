//
//  IBActionSheet.h
//  InnerBand
//
//  Created by John Blanco on 12/1/12.
//
//

#import <Foundation/Foundation.h>

@interface IBActionSheet : UIActionSheet <UIActionSheetDelegate> {
    void (^actionBlock_)(NSInteger);
    void (^cancelBlock_)();
}

- (id)initWithTitle:(NSString *)title cancelBlock:(void (^)(void))cancelBlock  actionBlock:(void (^)(NSInteger))actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
