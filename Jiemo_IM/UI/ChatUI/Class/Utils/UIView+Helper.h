//
//  UIView+Helper.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/16.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIView (Helper)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

+ (instancetype)instantceWithNibName:(NSString *)nibName;

@end

@interface UIView (FindeFirstResponder)

/**
 找到第一响应者
 */
- (UIView *)findFirstResponder;

@end
