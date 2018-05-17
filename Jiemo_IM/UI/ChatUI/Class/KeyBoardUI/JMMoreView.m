//
//  JMMoreView.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMMoreView.h"
#import "UIView+Helper.h"

@implementation JMMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(30, 20, 60, 60);
        imageView.image = [UIImage imageNamed:@"photoImg"];
        [self addSubview:imageView];
        
        UILabel *label = [UILabel new];
        label.text = @"照片";
        label.frame = CGRectMake(30, imageView.bottom + 5, 60, 30);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

@end
