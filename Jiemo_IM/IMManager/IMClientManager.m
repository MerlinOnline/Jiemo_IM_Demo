//
//  IMClientManager.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "IMClientManager.h"
#import "ClientCoreSDK.h"
#import "ConfigEntity.h"
#import "LocalUDPDataSender.h"

@interface IMClientManager ()

// 设置事件回调通知监听
@property (strong, nonatomic) ChatBaseEventImpl *baseEventListener;
@property (strong, nonatomic) ChatTransDataEventImpl *transDataListener;
@property (strong, nonatomic) MessageQoSEventImpl *messageQoSListener;


@end

@implementation IMClientManager

// 创建静态对象 防止外部访问
static IMClientManager *instance = nil;
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
        [self initMobileIMSDK];
    }
    return self;
}

// 初始化IMSDK
- (void)initMobileIMSDK
{
    // 设置AppKey
    [ConfigEntity registerWithAppKey:@"5418023dfd98c579b6001741"];
    
    // 设置服务器ip和服务器端口
    [ConfigEntity setServerIp:@"rbcore.52im.net"];
    [ConfigEntity setServerPort:7901];
    
    // 使用以下代码表示不绑定固定port（由系统自动分配），否则使用默认的7901端口
//    [ConfigEntity setLocalUdpSendAndListeningPort:-1];
    
    // RainbowCore核心IM框架的敏感度模式设置(默认SenseMode3S模式)
    [ConfigEntity setSenseMode:SenseMode10S];
    
    // 开启DEBUG信息输出
//    [ClientCoreSDK setENABLED_DEBUG:YES];
    
    // 设置事件回调
    self.baseEventListener = [[ChatBaseEventImpl alloc] init];
    self.transDataListener = [[ChatTransDataEventImpl alloc] init];
    self.messageQoSListener = [[MessageQoSEventImpl alloc] init];
    [ClientCoreSDK sharedInstance].chatBaseEvent = self.baseEventListener;
    [ClientCoreSDK sharedInstance].chatTransDataEvent = self.transDataListener;
    [ClientCoreSDK sharedInstance].messageQoSEvent = self.messageQoSListener;
    
}

// 释放IMSDK
- (void)releaseMobileIMSDK
{
    [[ClientCoreSDK sharedInstance] releaseCore];
}


- (ChatTransDataEventImpl *) getTransDataListener
{
    return self.transDataListener;
}

- (ChatBaseEventImpl *) getBaseEventListener
{
    return self.baseEventListener;
}

- (MessageQoSEventImpl *) getMessageQoSListener
{
    return self.messageQoSListener;
}

- (void)loginImplWithUserId:(NSString *)userId andUserToken:(NSString*)userToken {
    
    // 准备好异步登陆结果回调block（将在登陆方法中使用）
    ObserverCompletion onLoginSucessObserver = ^(id observerble ,id data) {

        // 服务端返回的登陆结果值
        int code = [(NSNumber *)data intValue];
        // 登陆成功
        if(code == 0)
        {
            // TODO 提示：登陆MobileIMSDK服务器成功后的事情在此实现即可

            // 进入主界面
            
        }
        // 登陆失败
        else
        {
            NSLog(@"Sorry，登陆失败，错误码=%d", code);
        }
        
        //## try to bug FIX ! 20160810：此observer本身执行完成才设置为nil，解决之前过早被nil而导致有时怎么也无法跳过登陆界面的问题
        // * 取消设置好服务端反馈的登陆结果观察者（当客户端收到服务端反馈过来的登陆消息时将被通知）【1】
        [[[IMClientManager sharedInstance] getBaseEventListener] setLoginOkForLaunchObserver:nil];
    };
    
    [[[IMClientManager sharedInstance] getBaseEventListener] setLoginOkForLaunchObserver:onLoginSucessObserver];
    
    // * 发送登陆数据包(提交登陆名和密码)
    int code = [[LocalUDPDataSender sharedInstance] sendLogin:userId withToken:userToken];
    if(code == COMMON_CODE_OK)
    {
        NSLog(@"登陆请求已发出。。。");
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"登陆请求发送失败，错误码：%d", code];
        NSLog(@"%@" ,msg);
    }
}

- (void)logoutImpl {
    // 发出退出登陆请求包
    int code = [[LocalUDPDataSender sharedInstance] sendLoginout];
    if(code == COMMON_CODE_OK)
    {
        NSLog(@"注销登陆请求已完成。。。");
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"注销登陆请求发送失败，错误码：%d", code];
        NSLog(@"%@" ,msg);
    }
}

- (void)sendMessageDataWithMsg:(NSString *)msg toFriendId:(NSString *)friendId {
    // 发送消息
    int code = [[LocalUDPDataSender sharedInstance] sendCommonDataWithStr:msg toUserId:friendId qos:YES fp:nil withTypeu:-1];
    if(code == COMMON_CODE_OK)
    {
        NSLog(@"您的消息已成功发出。。。");
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"您的消息发送失败，错误码：%d", code];
        NSLog(@"%@" ,message);
    }
}

@end
