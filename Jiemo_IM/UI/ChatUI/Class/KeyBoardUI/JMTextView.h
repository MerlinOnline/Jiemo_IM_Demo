//
//  JMTextView.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextHeightChangedBlock)(CGFloat textHeight);
@interface JMTextView : UITextView

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 文字大小
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) TextHeightChangedBlock textChangedBlock;

- (void)textValueDidChanged:(TextHeightChangedBlock)block;

@end
