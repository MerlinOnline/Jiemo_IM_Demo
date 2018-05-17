//
//  JMKeyBoardView.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMKeyBoardView;
@protocol JMKeyBoardDelegate <NSObject>

@optional //非必实现的方法

// 发送文字
- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendMessage:(NSString *)message;

// 发送图片
- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendPicture:(UIImage *)image;

// 发送语音
- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY;

@end

@interface JMKeyBoardView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id <JMKeyBoardDelegate>delegate;

@end
