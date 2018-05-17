//
//  DataBaseManager.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessage.h"

@interface DataBaseManager : NSObject

+ (instancetype)sharedInstance;

#pragma mark - ChatMessage
/**
 *  添加chatMessage
 *
 */
- (void)addChatMessage:(ChatMessage *)chatMessage;
/**
 *  删除chatMessage
 *
 */
- (void)deleteChatMessage:(ChatMessage *)chatMessage;
/**
 *  更新chatMessage
 *
 */
- (void)updateChatMessage:(ChatMessage *)chatMessage;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllChatMessage;

@end
