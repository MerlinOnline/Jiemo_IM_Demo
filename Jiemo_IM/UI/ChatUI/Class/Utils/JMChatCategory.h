//
//  JMChatCategory.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (JMChatCategory)

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGRect)screenBounds;
+ (CGSize)screenSize;

@end


@interface UIDevice(JMChatCategory)

+ (BOOL)isIPhone;

+ (BOOL)isIPhoneX;

@end



@interface UIImage (JMChatCategory)

/**
 *  本地 UIImage 获取
 */
+ (nullable instancetype)imageWithName:(NSString *)imageName;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


@interface NSBundle(JMChatCategory)
/**
 *  pod库本地bundle文件获取
 */
+ (nullable instancetype)photoViewerResourceBundle;

@end

@interface NSString(JMChatCategory)

- (CGSize)sizeWithFont:(UIFont *)font;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end



@interface UIResponder(JMChatCategory)

- (nullable __kindof UIResponder *)findNextResonderInClass:(nonnull Class)responderClass;

@end


NS_ASSUME_NONNULL_END
