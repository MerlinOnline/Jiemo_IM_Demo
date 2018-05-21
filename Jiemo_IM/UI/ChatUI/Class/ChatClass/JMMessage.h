//
//  JMMessage.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

/*
 {
 "msgId": "5I02W-16-8278a", //消息ID
 "timestamp": 1403099033211, //消息发送时间(13位时间戳)
 "msg": "这是消息内容", //消息内容
 "msgType": 1, //消息类型 1:文本  2:图片
 "chatType": 1, //用来判断单聊还是群聊。1: 群聊 2:单聊
 
 "toUserId": "1402541206787", //接收人的Id
 "toUserName": "大牛1号", //接收人的username
 "toUserHeadImgUrl": "www.qq.com", //接收人的头像地址
 
 "fromUserId": "1402541206787", //接收人的Id
 "fromUserName": "大牛1号", //接收人的username
 "fromUserHeadImgUrl": "www.qq.com", //接收人的头像地址
 
 "groupName": "大牛群", //群名称    （当chatType为1群聊时才会有值，否则为null）
 "groupId": 123, //群id（当chatType为1群聊时才会有值，否则为null）
 }
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageType) {
    JMMessageTypeText     = 1 , // 文字
    JMMessageTypePicture  = 2 , // 图片
    JMMessageTypeVoice    = 3   // 语音
};

typedef NS_ENUM(NSInteger, MessageFrom) {
    JMMessageFromMe    = 0,   // 自己发的
    JMMessageFromOther = 1    // 别人发得
};

typedef NS_ENUM(NSInteger, MessageRoom) {
    MessageRoomGroup   = 1,   // 群聊
    MessageRoomChat    = 2    // 单聊
};


@interface JMMessage : NSObject

@property (nonatomic,   copy) NSString * msgId;       //消息ID
@property (nonatomic, assign) NSInteger timestamp;    //消息发送时间(13位时间戳)
@property (nonatomic,   copy) NSString * msg;         //消息内容
@property (nonatomic, assign) MessageType  msgType;   //消息类型 1:文本  2:图片
@property (nonatomic, assign) MessageRoom  chatType;  //用来判断单聊还是群聊。1: 群聊 2:单聊

@property (nonatomic,   copy) NSString * toUserId;          //接收人的Id
@property (nonatomic,   copy) NSString * toUserName;        //接收人的username
@property (nonatomic,   copy) NSString * toUserHeadImgUrl;  //接收人的头像地址

@property (nonatomic,   copy) NSString * fromUserId;          //接收人的Id
@property (nonatomic,   copy) NSString * fromUserName;        //接收人的username
@property (nonatomic,   copy) NSString * fromUserHeadImgUrl;  //接收人的头像地址

@property (nonatomic,   copy) NSString * groupName;  //群名称    （当chatType为1群聊时才会有值，否则为null）
@property (nonatomic,   copy) NSString * groupId;    //群id（当chatType为1群聊时才会有值，否则为null）

@property (nonatomic,   copy) NSString * msgTime;   // 消息时间
@property (nonatomic, assign) BOOL showDateLabel;   // 是否展示时间

@property (nonatomic,   copy) UIImage *picture;
@property (nonatomic,   copy) NSData * voice;       // 语音消息
@property (nonatomic,   copy) NSString * voiceTime; // 语音时长

@property (nonatomic, assign) MessageFrom from;


- (void)setWithDict:(NSDictionary *)dict;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;

@end
