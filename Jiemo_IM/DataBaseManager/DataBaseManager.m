//
//  DataBaseManager.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/17.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "DataBaseManager.h"
#import <FMDB.h>

@interface DataBaseManager ()

@property (nonatomic, strong) FMDatabase *dataBase;
@property (nonatomic, strong) NSString * filePath;

@end

@implementation DataBaseManager

// 创建静态对象 防止外部访问
static DataBaseManager *instance = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}
+(instancetype)sharedInstance
{
    return [[self alloc]init];
}
-(id)copyWithZone:(NSZone *)zone
{
    return instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return instance;
}

// 重写init实例方法实现。
- (instancetype)init {
    self = [super init];
    if (self) {
        [self creatTable];
    }
    return self;
}

#pragma mark - 创建数据库、创建表
- (void)creatTable {
    // 创建数据库
    // 1、找到数据库存储路径
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"document %@", document);
    self.filePath = [document stringByAppendingPathComponent:@"chatMessage.sqlite"];
    // 2、使用路径初始化FMDB对象
    self.dataBase = [FMDatabase databaseWithPath:self.filePath];
    // 3、判断数据库是否打开，打开时才执行sql语句
    if ([self.dataBase open]) {
        // 1、创建建表sql语句
        NSString *createSql = @"CREATE TABLE IF NOT EXISTS t_chatMessage(id integer primary key autoincrement not null, message_Id integer not null, userId text not null, nickName text not null, sex text not null, age integer not null, headUrl text not null, imageUrl text not null, content text not null);";
        BOOL result = [self.dataBase executeUpdate:createSql];
        if (result) {
            NSLog(@"建表成功");
        } else {
            NSLog(@"建表失败 %d", result);
        }
        
        // 2、增加表字段
        if (![self.dataBase columnExists:@"voiceUrl" inTableWithName:@"t_chatMessage"]) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",@"t_chatMessage" , @"voiceUrl"];
            BOOL worked = [self.dataBase executeUpdate:alertStr];
            if (worked) {
                NSLog(@"增加表字段成功");
            } else {
                NSLog(@"增加表字段失败 %d", result);
            }
        }
    }
    // 关闭数据库
    [self.dataBase close];
}

#pragma mark - 接口

- (void)addChatMessage:(ChatMessage *)chatMessage{
    [self.dataBase open];
    
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [self.dataBase executeQuery:@"SELECT * FROM t_chatMessage "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"message_Id"] integerValue]) {
            maxID = @([[res stringForColumn:@"message_Id"] integerValue] ) ;
        }
        
    }
    maxID = @([maxID integerValue] + 1);    
    [self.dataBase executeUpdate:@"INSERT INTO t_chatMessage(message_Id, userId, nickName, sex, age, headUrl, imageUrl, content)VALUES(?,?,?,?,?,?,?,?)", maxID, chatMessage.userId, chatMessage.nickName, @(chatMessage.sex), @(chatMessage.age), chatMessage.headUrl, chatMessage.imageUrl, chatMessage.content];

    [self.dataBase close];
    
}

- (void)deleteChatMessage:(ChatMessage *)chatMessage{
    [self.dataBase open];
    
    [self.dataBase executeUpdate:@"DELETE FROM t_chatMessage WHERE message_Id = ?",@(chatMessage.message_Id)];
    
    [self.dataBase close];
}

- (void)updateChatMessage:(ChatMessage *)chatMessage{
    [self.dataBase open];
    
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET userId = ?  WHERE message_Id = ? ",chatMessage.userId,@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET nickName = ?  WHERE message_Id = ? ",chatMessage.nickName,@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET sex = ?  WHERE message_Id = ? ",@(chatMessage.sex),@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET age = ?  WHERE message_Id = ? ",@(chatMessage.age),@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET headUrl = ?  WHERE message_Id = ? ",chatMessage.headUrl,@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET imageUrl = ?  WHERE message_Id = ? ",chatMessage.imageUrl,@(chatMessage.message_Id)];
    [self.dataBase executeUpdate:@"UPDATE 't_chatMessage' SET content = ?  WHERE message_Id = ? ",chatMessage.content,@(chatMessage.message_Id)];
    
    [self.dataBase close];
}

- (NSMutableArray *)getAllChatMessage{
    [self.dataBase open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [self.dataBase executeQuery:@"SELECT * FROM t_chatMessage"];
    
    while ([res next]) {
        ChatMessage *message = [[ChatMessage alloc] init];
        message.message_Id = [[res stringForColumn:@"message_Id"] integerValue];
        message.userId = [res stringForColumn:@"userId"];
        message.nickName = [res stringForColumn:@"nickName"];
        message.sex = [[res stringForColumn:@"sex"] integerValue];
        message.age = [[res stringForColumn:@"age"] integerValue];
        message.headUrl = [res stringForColumn:@"headUrl"];
        message.imageUrl = [res stringForColumn:@"imageUrl"];
        message.content = [res stringForColumn:@"content"];
        
        [dataArray addObject:message];
        
    }
    
    [self.dataBase close];
    
    return dataArray;
}

@end
