//
//  JMMessage.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageType) {
    JMMessageTypeText     = 0 , // 文字
    JMMessageTypePicture  = 1 , // 图片
    JMMessageTypeVoice    = 2   // 语音
};

typedef NS_ENUM(NSInteger, MessageFrom) {
    JMMessageFromMe    = 0,   // 自己发的
    JMMessageFromOther = 1    // 别人发得
};


@interface JMMessage : NSObject

@property (nonatomic, copy) NSString *strIcon;
@property (nonatomic, copy) NSString *strId;
@property (nonatomic, copy) NSString *strTime;
@property (nonatomic, copy) NSString *strName;

@property (nonatomic, copy) NSString *strContent;
@property (nonatomic, copy) UIImage  *picture;
@property (nonatomic, copy) NSData   *voice;
@property (nonatomic, copy) NSString *strVoiceTime;

@property (nonatomic, assign) MessageType type;
@property (nonatomic, assign) MessageFrom from;

@property (nonatomic, assign) BOOL showDateLabel;

- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
