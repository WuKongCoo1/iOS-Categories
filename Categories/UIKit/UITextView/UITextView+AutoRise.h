//
//  UITextView+AutoRise.h
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/6/8.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (AutoRise)

@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, copy) void (^handler)(CGFloat expectHeight);

- (void)addAutoRiseHandlerWithdefaultHeight:(CGFloat)defaultHeight maxHeight:(CGFloat)maxHeight handler:(void (^)(CGFloat expectHeight))handler;

@end
