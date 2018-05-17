//
//  IMClientManager.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatBaseEventImpl.h"
#import "ChatTransDataEventImpl.h"
#import "MessageQoSEventImpl.h"

@interface IMClientManager : NSObject

// 取得本类实例的唯一公开方法。
+ (instancetype)sharedInstance;

// 初始化IMSDK
- (void)initMobileIMSDK;

- (void)releaseMobileIMSDK;


- (ChatTransDataEventImpl *) getTransDataListener;
- (ChatBaseEventImpl *) getBaseEventListener;
- (MessageQoSEventImpl *) getMessageQoSListener;


/**
 登录IM操作

 @param userId 用户账号
 @param userToken 用户密码
 */
- (void)loginImplWithUserId:(NSString *)userId andUserToken:(NSString*)userToken;

// 注销IM登录
- (void)logoutImpl;

// 发送IM消息
- (void)sendMessageDataWithMsg:(NSString *)msg toFriendId:(NSString *)friendId;

@end
