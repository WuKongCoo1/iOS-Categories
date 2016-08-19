//
//  UIView+LineAdditions.h
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/8/4.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LineAdditions)

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *rightLine;

- (void)addTopLineWithOffset:(CGFloat)offset color:(UIColor *)color;
- (void)addLeftLineWithOffset:(CGFloat)offset color:(UIColor *)color;
- (void)addRightLineWithOffset:(CGFloat)offset color:(UIColor *)color;
- (void)addBottomLineWithOffset:(CGFloat)offset color:(UIColor *)color;

@end
