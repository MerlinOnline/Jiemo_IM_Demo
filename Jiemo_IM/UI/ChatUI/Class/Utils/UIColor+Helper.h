//
//  UIColor+Helper.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/16.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue;
+ (UIColor *)rgbColorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
+ (UIColor *)colorWithHexString: (NSString *)color;
+ (UIColor *)colorWithHexString: (NSString *)color alpha:(float)alpha;
+ (UIColor *)randomColor;

@end
