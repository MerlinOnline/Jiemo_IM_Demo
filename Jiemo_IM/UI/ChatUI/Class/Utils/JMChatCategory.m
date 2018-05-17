//
//  JMChatCategory.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMChatCategory.h"

@implementation UIScreen (JMChatCategory)

+ (CGFloat)screenWidth
{
    return [self screenSize].width;
}

+ (CGFloat)screenHeight
{
    return [self screenSize].height;
}

+ (CGSize)screenSize
{
    return [self screenBounds].size;
}

+ (CGRect)screenBounds
{
    return [UIScreen mainScreen].bounds;
}

@end


@implementation UIDevice(JMChatCategory)

+ (BOOL)isIPhone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isIPhoneX
{
#ifdef __IPHONE_11_0
    return CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size);
#else
    return NO;
#endif
}

@end



@implementation UIImage(JMChatCategory)

+ (nullable instancetype)imageWithName:(NSString *)imageName
{
    //NOTE: @"image/%@" 不要写成 @"/image/%@"
    NSString *bundleImageName = [NSString stringWithFormat:@"image/%@",imageName];
    UIImage *image = [UIImage imageNamed:bundleImageName inBundle:[NSBundle photoViewerResourceBundle] compatibleWithTraitCollection:nil];
    image = image ?: [UIImage imageNamed:[NSString stringWithFormat:@"CKPhotoBrowser.bundle/image/%@",imageName]];
    return image ?: [UIImage imageNamed:imageName];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation NSBundle(JMChatCategory)

+ (nullable instancetype)photoViewerResourceBundle
{
    NSString *resourceBundlePath = [[NSBundle bundleForClass:[NSObject class]] pathForResource:@"UUChatTableView" ofType:@"bundle"];
    return [self bundleWithPath:resourceBundlePath];
}

@end



@implementation NSString(JMChatCategory)

- (CGSize)sizeWithFont:(UIFont *)font
{
    CGSize result = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    result.height = ceilf(result.height);
    result.width = ceilf(result.width);
    return result;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
    result.height = ceilf(result.height);
    result.width = ceilf(result.width);
    return result;
}

@end



@implementation UIResponder(JMChatCategory)

- (nullable __kindof UIResponder *)findNextResonderInClass:(nonnull Class)responderClass
{
    UIResponder *next = self;
    do {
        next = [next nextResponder];
        if ([next isKindOfClass:responderClass]) {
            break;
        }
        // next 不为空 且 不是达到最底层的 appdelegate
    } while (next!=nil && ![next conformsToProtocol:@protocol(UIApplicationDelegate)]);
    
    return next;
}

@end
