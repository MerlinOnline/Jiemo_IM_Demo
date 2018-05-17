//
//  JMMessageFrame.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMMessageFrame.h"
#import "JMMessage.h"
#import "JMChatCategory.h"

@implementation JMMessageFrame

- (void)setMessage:(JMMessage *)message{
    
    _message = message;
    
    CGFloat const screenW = [UIScreen screenWidth];
    
    // 1、计算时间的位置
    if (_showTime){
        CGSize timeSize = [_message.strTime sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(300, 100)];
        _timeF = CGRectMake((screenW - timeSize.width) / 2, ChatMargin, timeSize.width, timeSize.height);
    } else {
        _timeF = CGRectZero;
    }
    
    // 2、计算头像位置
    CGFloat const iconX = _message.from == JMMessageFromOther ? ChatMargin : (screenW - ChatMargin - ChatIconWH);
    _iconF = CGRectMake(iconX, CGRectGetMaxY(_timeF) + ChatMargin, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    CGSize nameSize = [_message.strName sizeWithFont:ChatTimeFont constrainedToSize:CGSizeMake(ChatIconWH+ChatMargin, 50)];
    _nameF = CGRectMake(iconX-ChatMargin/2.0, CGRectGetMaxY(_iconF) + ChatMargin/2.0, ChatIconWH+ChatMargin, nameSize.height);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + ChatMargin;
    
    //根据种类分
    CGSize contentSize;
    switch (_message.type) {
        case JMMessageTypeText:
            contentSize = [_message.strContent sizeWithFont:ChatContentFont constrainedToSize:CGSizeMake(MAX(ChatContentW, screenW*0.6), CGFLOAT_MAX)];
            contentSize.height = MAX(contentSize.height, 30);
            contentSize.width = MAX(contentSize.width, 40);
            break;
        case JMMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            break;
        case JMMessageTypeVoice:
            contentSize = CGSizeMake(120, 35);
            break;
        default:
            break;
    }
    if (_message.from == JMMessageFromMe) {
        contentX = screenW - (contentSize.width + ChatContentBiger + ChatContentSmaller + ChatMargin + ChatIconWH + ChatMargin);
    }
    _contentF = CGRectMake(contentX, CGRectGetMinY(_iconF) + 5, contentSize.width + ChatContentBiger + ChatContentSmaller, contentSize.height + ChatContentTopBottom * 2);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
}

- (void)setShowTime:(BOOL)showTime
{
    _showTime = showTime;
    
    if (_message) {
        self.message = _message;
    }
}

@end
