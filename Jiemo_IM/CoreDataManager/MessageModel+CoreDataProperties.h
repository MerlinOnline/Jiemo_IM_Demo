//
//  MessageModel+CoreDataProperties.h
//  
//
//  Created by merrill on 2018/5/18.
//
//

#import "MessageModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MessageModel (CoreDataProperties)

+ (NSFetchRequest<MessageModel *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *headUrl;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nonatomic) int64_t message_id;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nonatomic) int16_t sex;
@property (nullable, nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
