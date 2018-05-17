//
//  MainViewController.m
//  JM_IM_Demo
//
//  Created by merrill on 2018/5/15.
//  Copyright © 2018年 Tim2018. All rights reserved.
//

#import "MainViewController.h"
#import "IMClientManager.h"
#import "DataBaseManager.h"
#import "ChatViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTK;
@property (weak, nonatomic) IBOutlet UITextField *friendIdTf;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"homeText", nil);
    [self initDatabase];
 
}

- (void)initDatabase {
    
    ChatMessage *message = [ChatMessage new];
    message.message_Id = 1;
    message.userId = @"im_10001";
    message.nickName = @"Tim";
    message.age = 27;
    message.sex = 1;
    message.headUrl = @"https://www.baidu.com";
    message.imageUrl = @"https://www.baidu.com";
    message.content = @"我操了你大爷!";
//    [[DataBaseManager sharedInstance] addChatMessage:message];
//    [[DataBaseManager sharedInstance] updateChatMessage:message];
    [[DataBaseManager sharedInstance] deleteChatMessage:message];
    
    
    NSArray *dataSource = [[DataBaseManager sharedInstance] getAllChatMessage];
    NSLog(@"dataSource : %@" , dataSource);
}

- (IBAction)loginBtnClick:(id)sender {
    
    [[IMClientManager sharedInstance] loginImplWithUserId:self.accountTF.text andUserToken:self.passwordTK.text];
}

- (IBAction)logoutBtnClick:(id)sender {
    [[IMClientManager sharedInstance] logoutImpl];
}

- (IBAction)senderMsgBtnClick:(id)sender {
    [self.friendIdTf resignFirstResponder];
    ChatViewController *chatVC = [ChatViewController new];
    chatVC.friendId = self.friendIdTf.text;
    [self.navigationController pushViewController:chatVC animated:YES];
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
