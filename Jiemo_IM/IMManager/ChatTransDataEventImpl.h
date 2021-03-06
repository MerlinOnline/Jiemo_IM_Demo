//
//  ChatTransDataEventImpl.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatTransDataEvent.h"

@interface ChatTransDataEventImpl : NSObject <ChatTransDataEvent>

@property (nonatomic, copy) void (^receiveMessageObserver)(NSDictionary *msgDic);

@end
