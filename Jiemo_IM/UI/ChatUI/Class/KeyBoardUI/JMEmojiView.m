//
//  JMEmojiView.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMEmojiView.h"

@implementation JMEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.text = @"😁";
        label.frame = CGRectMake(30, 20, 30, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
