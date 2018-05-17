//
//  ChatBaseEventImpl.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBaseEvent.h"
#import "CompletionDefine.h"

@interface ChatBaseEventImpl : NSObject<ChatBaseEvent>

/** 本Observer目前仅用于登陆时（因为登陆与收到服务端的登陆验证结果是异步的，所以有此观察者来完成收到验证后的处理）*/
@property (nonatomic, copy) ObserverCompletion loginOkForLaunchObserver;// block代码块一定要用copy属性，否则报错！

@end
