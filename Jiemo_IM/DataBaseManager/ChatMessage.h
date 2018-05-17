//
//  ChatMessage.h
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property (nonatomic, assign) NSInteger  message_Id;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, assign) NSInteger  sex;
@property (nonatomic, assign) NSInteger  age;
@property (nonatomic, strong) NSString * headUrl;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * content;


@end
