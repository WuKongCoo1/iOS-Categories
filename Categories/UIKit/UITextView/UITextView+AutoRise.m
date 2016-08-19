//
//  UITextView+AutoRise.m
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/6/8.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "UITextView+AutoRise.h"
#import <objc/runtime.h>

static const void * UITextRiseMaxHeight = &UITextRiseMaxHeight;
static const void * UITextRiseDefaultHeight = &UITextRiseDefaultHeight;
static const void * UITextRiseHandler = &UITextRiseHandler;


@implementation UITextView (AutoRise)

- (void)addAutoRiseHandlerWithdefaultHeight:(CGFloat)defaultHeight maxHeight:(CGFloat)maxHeight handler:(void (^)(CGFloat))handler
{
    
    self.defaultHeight = defaultHeight;
    self.maxHeight = maxHeight;
    self.handler = handler;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChange:(NSNotification *)noti
{
    UITextView *inputTextView = noti.object;
    
    if (inputTextView != self) {
        return;
    }
    
    CGFloat expectHeight = 0.f;
    
    CGSize contentSize = inputTextView.contentSize;
    
    
    
    
    if(contentSize.height <= self.defaultHeight){
        
        expectHeight = self.defaultHeight;
        
    }else{
        
        expectHeight = contentSize.height;
        expectHeight = expectHeight > self.maxHeight ? self.maxHeight : expectHeight;
        
        if (expectHeight < self.maxHeight) {
            [inputTextView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    
    
    
    
    if (self.handler) {
        self.handler(expectHeight);
    }
    
}

- (CGFloat)maxHeight
{
    return [objc_getAssociatedObject(self, UITextRiseMaxHeight) floatValue];
}

- (CGFloat)defaultHeight
{
    return  [objc_getAssociatedObject(self, UITextRiseDefaultHeight) floatValue];
}

- (void (^)(CGFloat))handler
{
    return objc_getAssociatedObject(self, UITextRiseHandler);
}

-(void)setDefaultHeight:(CGFloat)defaultHeight
{
    objc_setAssociatedObject(self, UITextRiseDefaultHeight, @(defaultHeight), OBJC_ASSOCIATION_RETAIN);
    
    
}

- (void)setMaxHeight:(CGFloat)maxHeight
{
    objc_setAssociatedObject(self, UITextRiseMaxHeight, @(maxHeight), OBJC_ASSOCIATION_RETAIN);
}

- (void)setHandler:(void (^)(CGFloat))handler
{
    objc_setAssociatedObject(self, UITextRiseHandler, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)dealloc
{
    NSLog(@"");
}


@end
