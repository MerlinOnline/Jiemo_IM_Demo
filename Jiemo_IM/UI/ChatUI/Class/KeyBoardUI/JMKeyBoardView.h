//
//  JMKeyBoardView.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMKeyBoardDelegate <NSObject>

@optional //非必实现的方法

/**
 点击发送时输入框内的文案
 
 @param textStr 文案
 */
- (void)textViewContentText:(NSString *)textStr;

/**
 键盘的frame改变
 */
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY;

@end

@interface JMKeyBoardView : UIView <UITextViewDelegate>

@property (nonatomic, weak) id <JMKeyBoardDelegate>delegate;

@end
