//
//  UIView+LineAdditions.m
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/8/4.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "UIView+LineAdditions.h"
#import <objc/runtime.h>
#import <Masonry.h>

static char TopLineKey;
static char LeftLineKey;
static char RightLineKey;
static char BottomLineKey;

//@property (nonatomic, strong) UIView *topLine;
//@property (nonatomic, strong) UIView *leftLine;
//@property (nonatomic, strong) UIView *bottomLine;
//@property (nonatomic, strong) UIView *rightLine;

@implementation UIView (LineAdditions)

@dynamic topLine, leftLine, bottomLine, rightLine;

- (void)addTopLineWithOffset:(CGFloat)offset color:(UIColor *)color
{
    [self addSubview:self.topLine];
    self.topLine.backgroundColor = color;
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right);
        
        make.width.equalTo(self.mas_width).offset(-offset);
    }];
}

- (void)addLeftLineWithOffset:(CGFloat)offset color:(UIColor *)color
{
    UIView *line = self.leftLine;
    [self addSubview:line];
    line.backgroundColor = color;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(self.mas_height).offset(-offset);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)addRightLineWithOffset:(CGFloat)offset color:(UIColor *)color
{
    UIView *line = self.rightLine;
    [self addSubview:line];
    line.backgroundColor = color;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height).offset(-offset);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)addBottomLineWithOffset:(CGFloat)offset color:(UIColor *)color
{
    UIView *line = self.bottomLine;
    [self addSubview:line];
    line.backgroundColor = color;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
        make.right.equalTo(self.mas_right);
        
        make.width.equalTo(self.mas_width).offset(-offset);
    }];
}

#pragma mark - Runtime
- (UIView *)topLine
{
    UIView *line = objc_getAssociatedObject(self, &TopLineKey);
    if (line) {
        return line;
    }
    line = [[UIView alloc] init];
    
    objc_setAssociatedObject(self, &TopLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return line;
}

- (UIView *)leftLine
{
    UIView *line = objc_getAssociatedObject(self, &LeftLineKey);
    if (line) {
        return line;
    }
    line = [[UIView alloc] init];
    
    objc_setAssociatedObject(self, &LeftLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return line;
}

- (UIView *)rightLine
{
    UIView *line = objc_getAssociatedObject(self, &RightLineKey);
    if (line) {
        return line;
    }
    line = [[UIView alloc] init];
    
    objc_setAssociatedObject(self, &RightLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return line;
}

- (UIView *)bottomLine
{
    UIView *line = objc_getAssociatedObject(self, &BottomLineKey);
    if (line) {
        return line;
    }
    line = [[UIView alloc] init];
    
    objc_setAssociatedObject(self, &BottomLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return line;
}

@end
