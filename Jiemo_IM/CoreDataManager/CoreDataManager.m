//
//  CoreDataManager.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/18.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@interface CoreDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataManager

// 创建静态对象 防止外部访问
static CoreDataManager *instance = nil;
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

    }
    return self;
}

#pragma mark - Core Data

// 1、创建模型对象
- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        //获取模型路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
        //根据模型文件创建模型对象
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

// 2、创建持久化助理
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        //利用模型对象创建助理对象
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        //数据库的名称和路径
        NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlPath = [docStr stringByAppendingPathComponent:@"CoreDataModel.sqlite"];
        NSLog(@"path = %@", sqlPath);
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        //设置数据库相关信息
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
    }
    return _persistentStoreCoordinator;
}

// 3、创建上下文 保存信息 对数据库进行操作
- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //关联持久化助理
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _managedObjectContext;
}

// 新增数据
- (void)insertDataMessageModel:(MessageModel *)messageModel {
    
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类MessageModel
    MessageModel *msgModel = [NSEntityDescription insertNewObjectForEntityForName:@"MessageModel" inManagedObjectContext:self.managedObjectContext];
    
    // 2.根据表MessageModel中的键值，给NSManagedObject对象赋值
    msgModel.message_id = 1;
    msgModel.userId = @"Tim2048";
    msgModel.nickName = @"Tim";
    msgModel.sex = 1;
    msgModel.age = 27;
    msgModel.content = @"我曹";
    
    //   3.保存插入的数据
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"数据插入到数据库成功");
    }else{
        NSLog(@"数据插入到数据库失败, %@",error);
    }
}

// 删除数据
- (void)deleteDataMessageModel:(MessageModel *)messageModel {
    
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageModel"];
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"message_id < %d", 10];
    deleRequest.predicate = pre;
    //返回需要删除的对象数组
    NSArray *deleArray = [self.managedObjectContext executeFetchRequest:deleRequest error:nil];
    //从数据库中删除
    for (MessageModel *msgModel in deleArray) {
        [self.managedObjectContext deleteObject:msgModel];
    }
    
    NSError *error = nil;
    //保存--记住保存
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"删除数据成功!!!");
    }else{
        NSLog(@"删除数据失败, %@", error);
    }
}

// 更新、修改数据
- (void)updateDataMessageModel:(MessageModel *)messageModel{
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MessageModel"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"message_id < %d", 10];
    request.predicate = pre;
    
    //发送请求
    NSArray *resArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    //修改
    for (MessageModel *msgModel in resArray) {
        msgModel.nickName = @"TOTO";
    }
    
    //保存
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        NSLog(@"更新、修改数据成功");
    }else{
        NSLog(@"更新数据失败, %@", error);
    }
}

//读取查询
- (NSArray *)readDataMessageModel:(MessageModel *)messageModel{
    
    /* 谓词的条件指令
     1.比较运算符 > 、< 、== 、>= 、<= 、!=
     例：@"number >= 99"
     
     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"
     
     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"
     
     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
     
     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   //*代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"
     
     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符
     
     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex
     
     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
     
     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
     
     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K
     
     */
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MessageModel"];
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"message_id = %ld", 1];
    request.predicate = pre;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray *resArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return resArray;
}

//排序
- (NSArray *)sortData{
    //创建排序请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"MessageModel"];
    //实例化排序对象
    NSSortDescriptor *ageSort = [NSSortDescriptor sortDescriptorWithKey:@"age"ascending:YES];
    NSSortDescriptor *numberSort = [NSSortDescriptor sortDescriptorWithKey:@"message_id"ascending:YES];
    request.sortDescriptors = @[ageSort,numberSort];
    //发送请求
    NSError *error = nil;
    NSArray *resArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error == nil) {
        NSLog(@"按照age和number排序");
    }else{
        NSLog(@"排序失败, %@", error);
    }
    return resArray;
}


@end












