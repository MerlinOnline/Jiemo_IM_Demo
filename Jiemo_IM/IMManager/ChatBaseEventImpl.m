//
//  ChatBaseEventImpl.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "ChatBaseEventImpl.h"

@implementation ChatBaseEventImpl

// 登陆/掉线重连结果通知
- (void)onLoginMessage:(int)dwErrorCode
{
    if (dwErrorCode == 0)
        NSLog(@"IM服务器登录/连接成功！");
    else
        NSLog(@"登录失败，错误代码：%d", dwErrorCode);
    
}

// 掉线事件通知
- (void) onLinkCloseMessage:(int)dwErrorCode
{
    NSLog(@"网络连断开了，error：%d", dwErrorCode);
}

@end
