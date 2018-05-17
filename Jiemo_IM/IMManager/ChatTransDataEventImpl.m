//
//  ChatTransDataEventImpl.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "ChatTransDataEventImpl.h"

@implementation ChatTransDataEventImpl

// 收到用户消息
- (void) onTransBuffer:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)dwUserid andContent:(NSString *)dataContent andTypeu:(int)typeu
{
    NSLog(@"[%d]收到来自用户%@的消息:%@", typeu, dwUserid, dataContent);
    NSDictionary *msgDic = @{@"userId": dwUserid,
                             @"message": dataContent};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JMReceiveMessageNotification" object:msgDic];
}

// 收到服务器错误信息
- (void) onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"收到服务端错误消息，errorCode=%d, errorMsg=%@", errorCode, errorMsg);

    if(errorCode == ForS_RESPONSE_FOR_UNLOGIN)
    {
        NSString *content = [NSString stringWithFormat:@"服务端会话已失效，自动登陆/重连将启动! (%d)", errorCode];
        NSLog(@"%@" ,content);
    }
    else
    {
        NSString *content = [NSString stringWithFormat:@"Server反馈错误码：%d,errorMsg=%@", errorCode, errorMsg];
        NSLog(@"%@" ,content);
    }
}

@end
