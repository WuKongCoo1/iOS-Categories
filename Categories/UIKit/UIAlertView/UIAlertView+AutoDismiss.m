//
//  UIAlertView+AutoDismiss.m
//  Category
//
//  Created by 吴珂 on 15/11/13.
//  Copyright © 2015年 MyCompany. All rights reserved.
//

#import "UIAlertView+AutoDismiss.h"

@implementation UIAlertView (AutoDismiss)

+ (void)alertViewAutoDismissTitle:(NSString *)title message:(NSString *)message
{
    [self alertViewAutoDismissWithTime:1.f title:title message:message];
}

+ (void)alertViewAutoDismissWithTime:(NSTimeInterval)time title:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    alertView.delegate = self;
    
    [alertView show];
 
    [NSTimer scheduledTimerWithTimeInterval:time target:alertView selector:@selector(autoDismiss:) userInfo:nil repeats:NO];
}

+ (void)alertViewAutoDismissWithMessage:(NSString *)message
{
    [self alertViewAutoDismissTitle:@"提示" message:message];
}

- (void)autoDismiss:(NSTimer *)timer
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}



@end
