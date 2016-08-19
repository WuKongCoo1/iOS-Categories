//
//  UIAlertView+AutoDismiss.h
//  Category
//
//  Created by 吴珂 on 15/11/13.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (AutoDismiss)

//@property (strong, nonatomic) NSTimer *timer;

+ (void)alertViewAutoDismissWithTime:(NSTimeInterval)time title:(NSString *)title message:(NSString *)message;

+ (void)alertViewAutoDismissTitle:(NSString *)title message:(NSString *)message;

+ (void)alertViewAutoDismissWithMessage:(NSString *)message;
@end
