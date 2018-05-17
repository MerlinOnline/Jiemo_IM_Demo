//
//  JMChatModel.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/16.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMMessageFrame;
@interface JMChatModel : NSObject

@property (nonatomic, strong) NSMutableArray<JMMessageFrame *> *dataSource;

@property (nonatomic) BOOL isGroupChat;


- (void)addSpecifiedItem:(NSDictionary *)dic;

- (void)recountFrame;

@end
