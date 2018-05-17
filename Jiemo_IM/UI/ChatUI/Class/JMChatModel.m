//
//  JMChatModel.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/16.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "JMChatModel.h"
#import "JMMessage.h"
#import "JMMessageFrame.h"

@implementation JMChatModel

- (instancetype)init {
    if ([super init]) {
        self.dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)recountFrame
{
    [self.dataSource enumerateObjectsUsingBlock:^(JMMessageFrame * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.message = obj.message;
    }];
}

// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    JMMessageFrame *messageFrame = [[JMMessageFrame alloc]init];
    JMMessage *message = [[JMMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    if ([dic[@"isMe"] boolValue]) {
        [dataDic setObject:@(JMMessageFromMe) forKey:@"from"];
        [dataDic setObject:@"Tim2048" forKey:@"strName"];
    }else {
        [dataDic setObject:@(JMMessageFromOther) forKey:@"from"];
        [dataDic setObject:dic[@"userId"] forKey:@"strName"];
    }
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

@end
