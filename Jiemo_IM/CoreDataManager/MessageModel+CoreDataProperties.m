//
//  MessageModel+CoreDataProperties.m
//  
//
//  Created by merrill on 2018/5/18.
//
//

#import "MessageModel+CoreDataProperties.h"

@implementation MessageModel (CoreDataProperties)

+ (NSFetchRequest<MessageModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MessageModel"];
}

@dynamic age;
@dynamic content;
@dynamic headUrl;
@dynamic imageUrl;
@dynamic message_id;
@dynamic nickName;
@dynamic sex;
@dynamic userId;

@end
