//
//  ChatViewController.m
//  Jiemo_IM
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "ChatViewController.h"
#import "JMMessageCell.h"
#import "JMMessageFrame.h"
#import "JMMessage.h"
#import "JMChatCategory.h"
#import "JMChatModel.h"
#import "IMClientManager.h"

#import "JMKeyBoardView.h"
#import "UIView+Helper.h"


//状态栏和导航栏的总高度
#define StatusNav_Height (isIphoneX ? 88 : 64)
//判断是否是iPhoneX
#define isIphoneX (K_Width == 375.f && K_Height == 812.f ? YES : NO)
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height self.view.frame.size.height
@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource ,JMKeyBoardDelegate,JMMessageCellDelegate>
{
    CGFloat _keyboardHeight;
    CGFloat changeValue;
}

@property (nonatomic, strong) JMChatModel * chatModel;

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) JMKeyBoardView *inputView;

@end

@implementation ChatViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustCollectionViewLayout) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self tableViewScrollToBottom];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBasicViews];
    [self loadBaseViewsAndData];
}

- (void)initBasicViews {
    
    self.title = self.friendId;
    self.view.backgroundColor = [UIColor purpleColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = YES;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[JMMessageCell class] forCellReuseIdentifier:NSStringFromClass([JMMessageCell class])];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (@available(iOS 11.0, *)) {
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedRowHeight = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //添加输入框
    self.inputView = [[JMKeyBoardView alloc] initWithFrame:CGRectMake(0, K_Height - StatusNav_Height - 52, K_Width, 52)];
    //设置代理方法
    self.inputView.delegate = self;
    [self.view addSubview:_inputView];
}

// 初始化model
- (void)loadBaseViewsAndData
{
    self.chatModel = [[JMChatModel alloc] init];
    self.chatModel.isGroupChat = NO;
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotification:) name:@"JMReceiveMessageNotification" object:nil];
}

- (void)receiveMessageNotification:(NSNotification*)notice {
    
    NSDictionary *msgDic = notice.object;
    NSDictionary *dic = @{@"strContent": msgDic[@"message"],
                          @"userId":msgDic[@"userId"],
                          @"type": @(JMMessageTypeText),
                          @"isMe":@NO};
    [self dealTheFunctionData:dic];
}

#pragma mark - JMKeyBoardDelegate

- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(JMMessageTypeText),
                          @"isMe": @YES};
    [self dealTheFunctionData:dic];
    [[IMClientManager sharedInstance] sendMessageDataWithMsg:message toFriendId:self.friendId];
}

- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(JMMessageTypePicture),
                          @"isMe": @YES};
    [self dealTheFunctionData:dic];
}

- (void)JMKeyBoardView:(JMKeyBoardView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(JMMessageTypeVoice),
                          @"isMe": @YES};
    [self dealTheFunctionData:dic];
}

//keyboard的frame改变
- (void)keyboardChangeFrameWithMinY:(CGFloat)minY {
    
    // 获取对应cell的rect值（其值针对于UITableView而言）
    NSInteger lastCount = self.chatModel.dataSource.count - 1;
    lastCount = lastCount >= 0 ? lastCount : 0;
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:lastCount inSection:0];
    CGRect rect = [self.tableView rectForRowAtIndexPath:lastIndex];
    CGFloat lastMaxY = rect.origin.y + rect.size.height;
    //如果最后一个cell的最大Y值大于tableView的高度
    if (lastMaxY <= self.tableView.height) {
        if (lastMaxY >= minY) {
            self.tableView.top = minY - lastMaxY;
        } else {
            self.tableView.top = 0;
        }
    } else {
        self.tableView.top += minY - self.tableView.bottom;
    }
}

#pragma mark - InputFunctionViewDelegate

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}

- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0) { return; }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)adjustCollectionViewLayout
{
    [self.chatModel recountFrame];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JMMessageCell class])];
    cell.delegate = self;
    cell.messageFrame = self.chatModel.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UUMessageCellDelegate

- (void)chatCell:(JMMessageCell *)cell headImageDidClick:(NSString *)userId
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
