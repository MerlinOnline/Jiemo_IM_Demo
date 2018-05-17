//
//  MessageQoSEventImpl.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "MessageQoSEventImpl.h"

@implementation MessageQoSEventImpl

// 系统的未实时送达事件通知
- (void) messagesLost:(NSMutableArray*)lostMessages
{
    NSLog(@"【DEBUG_UI】收到系统的未实时送达事件通知，当前共有%li个包QoS保证机制结束，判定为【无法实时送达】！", (unsigned long)[lostMessages count]);
    
}

// 对方已收到消息事件的通知
- (void) messagesBeReceived:(NSString *)theFingerPrint
{
    if(theFingerPrint != nil)
    {
        NSLog(@"【DEBUG_UI】收到对方已收到消息事件的通知，fp=%@", theFingerPrint);
        
    }
}

@end
