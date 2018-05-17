//
//  UIView+Helper.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/16.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    return curve << 16;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}


+ (instancetype)instantceWithNibName:(NSString *)nibName {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    return array.firstObject;
}


- (NSString *)description
{
    return [UIView searchAllSubviews:self];
}

+ (NSString *)searchAllSubviews:(UIView *)superview
{
    NSMutableString *xml = [NSMutableString string];
    
    NSString *class = NSStringFromClass(superview.class);
    class = [class stringByReplacingOccurrencesOfString:@"_" withString:@""];
    [xml appendFormat:@"<%@ frame=\"%@\">\n", class, NSStringFromCGRect(superview.frame)];
    for (UIView *childView in superview.subviews) {
        NSString *subviewXml = [self searchAllSubviews:childView];
        [xml appendString:subviewXml];
    }
    [xml appendFormat:@"</%@>\n", class];
    return xml;
}

@end

@implementation UIView (FindeFirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *responder = [subView findFirstResponder];
        if (responder) {
            return responder;
        }
    }
    return nil;
}

@end
